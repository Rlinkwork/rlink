// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './libs/Math.sol';
import './libs/SafeMath.sol';
import './libs/SafeERC20.sol';
import './libs/Pausable.sol';
import './libs/BlackListable.sol';
import './interfaces/IRlink.sol';
import './interfaces/IRlinkRelation.sol';

contract RlinkRelation is Pausable,BlackListable,IRlinkRelation {
    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    mapping(address=>address) private _parents;

    mapping(address=>uint256) private _stakeBalances;

    mapping(address=>uint256) private _specialTrials;

    mapping(address=>StakeInfo) private _stakes;

    uint256 public override distributeFee;

    address public feeTo;

    uint256 public override bindReward;

    uint256 public override mintedRewards;

    uint256 public override remainingRewards;

    bool public override stakeEnabled;

    uint256 public stakeEnableTime;

    bool public verifyChild = false;    

    uint256 public constant distributeFeeCap = 1000 * 1e18;

    uint256 public constant override monthScale = 31 days;

    uint256 public constant override stakeBase = 10000 * 1e18;

    uint256 public override maxStakeMonth = 10;

    uint256 public override globalTrial = 0;

    bool public override withdrawEnabled = false;

    bool public override burnEnabled = false;

    bool public queryVerify = false;
  
    address public override immutable stakingToken;

    uint256 public immutable createTime;


    event DistributeFeeChanged(address sender, uint256 oldFee,uint256 newFee);

    event SetedSpecialTrials(address account,uint256 trialSeconds);

    event BindRewardChanged(address sender, uint256 oldReward,uint256 newReward);

    event AddedReward(uint256 amount);

    event StakeEnableChanged(address sender, bool enableStatus);

    event WithdrawEnableChanged(address sender,bool enableStatus);

    event BurnEnabledChanged(address sender,bool enableStatus);

    event MaxStakeMonthChanged(address sender,uint256 oldLimit,uint256 newLimit);

    event VerifyChildChanged(address sender,bool enableStatus);

    event GlobalTrialTimeChanged(address sender,uint256 oldTrialTime,uint256 newTrialTime);

    event FeeToChanged(address sender,address oldFeeTo,address newFeeTo);

    event BurnedStake(address sender,address account,uint256 amount);

    event Withdrawed(address account,uint256 amount);

    event DistributedParams(address token,address to,uint256 amount,uint256 incentiveRate,uint256 parentRate,uint256 grandpaRate);

    event QueryVerifyChanged(address sender,bool isEnable);

    struct StakeInfo {
        uint256 firstCallTime;
        uint256 stakedExpireAt;
        uint256 stakedMonthes;
    }

    modifier onlyGovernance(){
        require(owner() == _msgSender(), "Rlink: caller is not the governance");
        _;
    }

    constructor(address _stakingToken){
        stakingToken = _stakingToken;
        createTime = block.timestamp;
        feeTo = msg.sender;
    }

    function isParent(address child,address parent) external view override returns(bool) {
        return _parents[child] == parent;
    }

    function parentOf(address account) external view override returns(address) {
        if(queryVerify){
            require(_checkStake(msg.sender),"Rlink::distribute: insufficient stakes");
        }

        return _parents[account];
    }

    function addRelation(address _child, address _parent) external override whenNotPaused notBlackListed returns(bool) {
        require(_child != _parent,"Rlink::addRelation: parent can not be self");
        require(_child != address(0) && _parent != address(0),"Rlink::addRelation: child or parent can not be address 0");
        require(_parents[_child] == address(0),"Rlink::addRelation: child already has parent");
        require(_parents[_parent] != _child,"Rlink::addRelation: parent can not be descendant of child");
        require(!verifyChild || tx.origin == _child,"Rlink::addRelation: child must be tx origin");

        _parents[_child] = _parent;
        if(bindReward > 0 && remainingRewards >= bindReward){
            remainingRewards = remainingRewards.sub(bindReward);
            mintedRewards = mintedRewards.add(bindReward);
            IERC20(stakingToken).safeTransfer(msg.sender,bindReward);
        }

        emit AddedRelation(_child, _parent);
        return true;
    }

    function stake(address forAccount,uint256 amount) external override whenNotPaused notBlackListed returns(bool) {
        require(forAccount!=address(0),"Rlink::stake: can not stake for address 0");
        require(amount>0,"Rlink::stake: can not stake 0");
        require(stakeEnabled,"Rlink::stake: stake is not enabled");

        IERC20(stakingToken).safeTransferFrom(_msgSender(), address(this), amount);
        uint256 oldAmount=_stakeBalances[forAccount];
        uint256 newAmount=oldAmount.add(amount);
        require(newAmount <= maxStakeAmount(),"Rlink::stake: total staked of forAccount exceeds max stake amount");
        _stakeBalances[forAccount] = newAmount;

        uint256 oldStakedMonthes = calcStakeMonthes(oldAmount);
        uint256 newStakedMonthes = calcStakeMonthes(newAmount);
        if(newStakedMonthes > oldStakedMonthes){
            uint256 oldExpireAt = Math.max(_stakes[forAccount].stakedExpireAt,trialExpireAt(forAccount));
            _stakes[forAccount].stakedMonthes = newStakedMonthes;
            _stakes[forAccount].stakedExpireAt = Math.max(oldExpireAt,block.timestamp).add(newStakedMonthes.sub(oldStakedMonthes).mul(monthScale));
        }

        emit Staked(forAccount, amount);
        return true;
    } 

    function stakeOf(address account) external view override returns(uint256){
        return _stakeBalances[account];
    }

    function expireAt(address account) public view override returns(uint256) {
        if(_stakes[account].stakedMonthes >= maxStakeMonth){
            return type(uint256).max;
        }
        return Math.max(_stakes[account].stakedExpireAt,trialExpireAt(account));
    }

    function calcStakeMonthes(uint256 stakedAmount) public view returns(uint256) {
        uint256 stakeBase_ = stakeBase;
        if(stakedAmount<stakeBase_){
            return 0;
        }
        if(stakedAmount<stakeBase_.mul(3)){
            return 1;
        }
        if(stakedAmount >= maxStakeAmount()){
            return maxStakeMonth;
        }
        uint256 high = maxStakeMonth;
        uint256 low = 1;
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if ((1 + mid).mul(mid).div(2).mul(stakeBase_) > stakedAmount) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        
        return high == 1 ? 1 : high - 1;
    }

    function maxStakeAmount() public view override returns(uint256){
        uint256 m=maxStakeMonth;
        if(m == 1){
            return stakeBase;
        }
        
        return (1 + m).mul(m).div(2).mul(stakeBase);
    }

    function withdraw(address to) external override whenNotPaused notBlackListed {
        require(to!=address(0),"Rlink::withdraw: can not withdraw to address 0");
        require(withdrawEnabled,"Rlink::withdraw: withdraw is disabled");
        require(_stakeBalances[msg.sender]>0,"Rlink::withdraw: you have no stakes");

        uint256 stakeAmount = _stakeBalances[msg.sender];
        _stakeBalances[msg.sender] = 0;
        _stakes[msg.sender].stakedExpireAt=block.timestamp - 1;
        _stakes[msg.sender].stakedMonthes=0;
        IERC20(stakingToken).safeTransfer(to, stakeAmount);

        emit Withdrawed(msg.sender,stakeAmount);
    }
    
    function burnExpiredStake(address account) external override whenNotPaused notBlackListed {
        require(burnEnabled,"Rlink::burnExpiredStake: burn stake is disabled");
        require(createTime.add(10 * 31 * 86400) < block.timestamp,"Rlink::burnExpiredStake: contract must created 10 monthes");
        require(expireAt(account) < block.timestamp,"Rlink::burnExpiredStake: stake is not expired");
        require(_stakeBalances[account]>0,"Rlink::burnExpiredStake: account has no stakes");
        
        uint256 stakeBalance = _stakeBalances[account];
        _stakeBalances[account] = 0;
        IRlink(stakingToken).burn(stakeBalance);

        emit BurnedStake(msg.sender, account,stakeBalance);
    }

    function distribute(
        address token,
        address to,
        uint256 amount,
        uint256 incentiveRate,
        uint256 parentRate,
        uint256 grandpaRate
    ) external override whenNotPaused notBlackListed returns(uint256 distributedAmount) {
        require(amount>0,"Rlink::distribute:  can not distribute 0");
        require(to!=address(0),"Rlink::distribute:  to address can not be address 0");
        require(incentiveRate.add(parentRate).add(grandpaRate)<1e18,"Rlink::distribute: sum of the rates must less than 1e18");
        require(_checkStake(msg.sender),"Rlink::distribute: insufficient stakes");

        address sender=_msgSender();
        if(stakeEnabled && _stakes[sender].firstCallTime == 0){
            _stakes[sender].firstCallTime = block.timestamp;
        }
        _chargeDistributeFee(sender);

        IERC20 token_=IERC20(token);
        uint256 forGrandpaAmount = amount.mul(grandpaRate).div(1e18);
        uint256 forParentAmount = amount.mul(parentRate).div(1e18); 
        address parent_ = _parents[to];
        if(parent_ != address(0) && forParentAmount.add(forGrandpaAmount)>0){
            if(forParentAmount > 0){
                token_.safeTransferFrom(sender, parent_, forParentAmount);
            }
            if(forGrandpaAmount>0 && _parents[parent_] != address(0)){
                token_.safeTransferFrom(sender, _parents[parent_], forGrandpaAmount);
            }  
        }

        uint256 selfAmount = amount.sub(forParentAmount).sub(forGrandpaAmount);
        if(parent_ == address(0)){
            selfAmount = selfAmount.sub(amount.mul(incentiveRate).div(1e18));
        }
        token_.safeTransferFrom(sender,to,selfAmount);                     

        emit DistributedParams(token,to,amount,incentiveRate,parentRate,grandpaRate);
        emit Distributed(sender,token, to, selfAmount, forParentAmount, forGrandpaAmount);
        distributedAmount = selfAmount + forParentAmount + forGrandpaAmount;
    }

    function _checkStake(address account) internal view returns(bool){
        if(!stakeEnabled){
            return true;
        }

        return expireAt(account) > block.timestamp;
    }

    function trialExpireAt(address account) public view override returns(uint256){
        uint256 firstCallTs = _stakes[account].firstCallTime;
        uint256 checkStartAt = firstCallTs == 0 ? block.timestamp : Math.max(stakeEnableTime,firstCallTs);

        return checkStartAt.add(Math.max(_specialTrials[account], globalTrial));
    }

    function _chargeDistributeFee(address sender) internal {
        if(distributeFee>0){
            IERC20(stakingToken).safeTransferFrom(sender, feeTo, distributeFee);
        }
    }

    function firstCallTime(address account) external view returns(uint256) {
        return _stakes[account].firstCallTime;
    }

    function trialTimes(address account) external view returns(uint256){
        return Math.max(_specialTrials[account], globalTrial);
    }

    function setDistributeFee(uint256 newFee) external onlyGovernance {
        require(newFee <= distributeFeeCap,"newFee exceeds distribute fee cap");
        uint256 oldFee=distributeFee;
        distributeFee=newFee;

        emit DistributeFeeChanged(msg.sender, oldFee,newFee);
    }

    function setBindReward(uint256 newReward) external onlyGovernance {
        uint256 oldReward= bindReward;
        bindReward = newReward;

        emit BindRewardChanged(msg.sender, oldReward,newReward);
    }

    function addReward(uint256 addAmount) external onlyGovernance {
        require(addAmount>0,"addAmount can not be 0");
        IERC20(stakingToken).safeTransferFrom(msg.sender, address(this), addAmount);
        remainingRewards = remainingRewards.add(addAmount);

        emit AddedReward(addAmount);
    }

    function setStakeEnable(bool isEnable) external onlyGovernance {
        stakeEnabled = isEnable;
        if(isEnable && stakeEnableTime==0){
            stakeEnableTime=block.timestamp;
        }

        emit StakeEnableChanged(msg.sender,isEnable);
    }

    function setSpecialTrial(address account,uint256 trialSeconds) external onlyGovernance {
        _specialTrials[account] = trialSeconds;

        emit SetedSpecialTrials(account, trialSeconds);
    }    

    function setWithdrawEnable(bool isEnable) external onlyGovernance {
        withdrawEnabled = isEnable;

        emit WithdrawEnableChanged(msg.sender, isEnable);
    }

    function setMaxStakeMonth(uint256 newMaxStakeMonth) external onlyGovernance {
        require(newMaxStakeMonth > 0,"max stake month can not be 0");
        require(newMaxStakeMonth <= 10 * 12,"max stake month too high");
        uint256 oldMax = maxStakeMonth;
        maxStakeMonth = newMaxStakeMonth;

        emit MaxStakeMonthChanged(msg.sender, oldMax, newMaxStakeMonth);
    }

    function setVerifyChild(bool isEnable) external onlyGovernance {
        verifyChild=isEnable;

        emit VerifyChildChanged(msg.sender,isEnable);
    }

    function setGlobalTrial(uint256 _newTrialTime) external onlyGovernance {
        uint256 oldTrial_ = globalTrial;
        globalTrial = _newTrialTime;

        emit GlobalTrialTimeChanged(msg.sender,oldTrial_,_newTrialTime);
    }

    function setFeeTo(address newFeeTo) external onlyGovernance {
        require(newFeeTo!=address(0),"fee to can not be address 0");
        address oldFeeTo = feeTo;
        feeTo = newFeeTo;

        emit FeeToChanged(msg.sender, oldFeeTo, newFeeTo);
    }

    function setBurnEnable(bool isEnable) external onlyGovernance {
        burnEnabled=isEnable;

        emit BurnEnabledChanged(msg.sender,isEnable);
    }

    function setQueryVerify(bool isEnable) external onlyGovernance {
        queryVerify=isEnable;

        emit QueryVerifyChanged(msg.sender, isEnable);
    }

    function pause() external onlyGovernance {
        _pause();
    }

    function unpause() external onlyGovernance {
        _unpause();
    }

    function addBlackList(address _evilUser) external onlyGovernance {
        _addBlackList(_evilUser);
    }

    function removeBlackList(address _clearedUser) external onlyGovernance {
        _removeBlackList(_clearedUser);
    }
}