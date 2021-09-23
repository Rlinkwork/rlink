// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './libs/SafeMath.sol';
import './libs/SafeERC20.sol';
import './libs/Pausable.sol';
import './libs/Ownable.sol';
import './interfaces/IRlinkRelation.sol';

contract RlinkRelation is Ownable,Pausable,IRlinkRelation {
    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    mapping(address=>address) private _parents;
    uint256 public override bindReward;
    uint256 public override mintedRewards;
    uint256 public override remainingRewards;
    bool public verifyChild = false;      
    address public immutable rlt;

    event BindRewardChanged(address sender, uint256 oldReward,uint256 newReward);
    event AddedReward(uint256 amount);
    event VerifyChildChanged(address sender,bool enableStatus);

    modifier onlyGovernance(){
        require(owner() == _msgSender(), "Rlink: caller is not the governance");
        _;
    }

    constructor(address _rlt){
        rlt = _rlt;
    }

    function isParent(address child,address parent) external view override returns(bool) {
        return _parents[child] == parent;
    }

    function parentOf(address account) external view override returns(address) {
        return _parents[account];
    }

    function addRelation(address _child, address _parent) external override whenNotPaused returns(uint256) {
        require(_child != _parent,"Rlink::addRelation: parent can not be self");
        require(_child != address(0) && _parent != address(0),"Rlink::addRelation: child or parent can not be address 0");
        require(_parents[_child] == address(0),"Rlink::addRelation: child already has parent");
        require(_parents[_parent] != _child,"Rlink::addRelation: parent can not be descendant of child");
        require(!verifyChild || tx.origin == _child,"Rlink::addRelation: child must be tx origin");

        _parents[_child] = _parent;
        uint bindReward_ = bindReward;
        if(bindReward_ > 0 && remainingRewards >= bindReward_){
            remainingRewards = remainingRewards.sub(bindReward_);
            mintedRewards = mintedRewards.add(bindReward_);
            IERC20(rlt).safeTransfer(msg.sender,bindReward_);
        }

        emit AddedRelation(_child, _parent);
        return bindReward_;
    }

    function distribute(
        address token,
        address to,
        uint256 amount,
        uint256 incentiveAmount,
        uint256 parentAmount,
        uint256 grandpaAmount
    ) external override whenNotPaused returns(uint256 distributedAmount) {
        require(amount > 0,"Rlink::distribute:  can not distribute 0");
        require(to != address(0),"Rlink::distribute:  to address can not be address 0");
        require(incentiveAmount.add(parentAmount).add(grandpaAmount) <= amount,"Rlink::distribute: sum of the rates must less than 1e18");

        address sender = msg.sender;
        IERC20 token_ = IERC20(token);
        address parent_ = _parents[to];
        address grandpa_ = address(0);
        uint256 toParentAmount = 0;
        uint256 toGrandpaAmount = 0;
        if(parent_ != address(0) && parentAmount.add(grandpaAmount)>0){
            if(parentAmount > 0){
                token_.safeTransferFrom(sender, parent_, parentAmount);
                toParentAmount = parentAmount;
            }            
            if(grandpaAmount > 0){
                grandpa_ = _parents[parent_];
                if(grandpa_ != address(0)){
                    token_.safeTransferFrom(sender, grandpa_, grandpaAmount);
                    toGrandpaAmount = grandpaAmount;
                }
            }  
        }

        uint256 selfAmount = amount.sub(parentAmount).sub(grandpaAmount);
        if(parent_ == address(0)){
            selfAmount = selfAmount.sub(incentiveAmount);
        }
        if(selfAmount > 0){
            token_.safeTransferFrom(sender,to,selfAmount);     
        }                

        emit Distributed(sender, token, to, selfAmount, parent_, toParentAmount, grandpa_, toGrandpaAmount);
        distributedAmount = selfAmount + toParentAmount + toGrandpaAmount;
    }

    function setBindReward(uint256 newReward) external onlyGovernance {
        uint256 oldReward= bindReward;
        bindReward = newReward;

        emit BindRewardChanged(msg.sender, oldReward,newReward);
    }

    function addReward(uint256 addAmount) external onlyGovernance {
        require(addAmount>0,"addAmount can not be 0");
        IERC20(rlt).safeTransferFrom(msg.sender, address(this), addAmount);
        remainingRewards = remainingRewards.add(addAmount);

        emit AddedReward(addAmount);
    }

    function setVerifyChild(bool isEnable) external onlyGovernance {
        verifyChild=isEnable;

        emit VerifyChildChanged(msg.sender,isEnable);
    }

    function pause() external onlyGovernance {
        _pause();
    }

    function unpause() external onlyGovernance {
        _unpause();
    }
}