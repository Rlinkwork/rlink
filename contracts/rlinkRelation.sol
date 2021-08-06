// SPDX-License-Identifier: MIT

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
}