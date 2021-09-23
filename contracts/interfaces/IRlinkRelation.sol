// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IRlinkRelation {
    /**
     * @dev add address relation
     * @param _child: address of the child
     * @param _parent: address of the parent
     * @return reward rlt amount for add relation
     */
    function addRelation(address _child, address _parent) external returns(uint256);

    /**
     * @dev query child and parent is associated
     * @param child: address of the child
     * @param parent: address of the parent
     * @return child and parent is associated
     */
    function isParent(address child,address parent) external view returns(bool);

    /**
     * @dev query parent of address
     * @param account: address of the child
     * @return parent address
     */
    function parentOf(address account) external view returns(address);

    /**
    * @dev distribute token
    * you must approve bigger than 'amount' allowance of token for rlink relation contract before call
    * require (incentiveAmount + parentAmount + grandpaAmount) <= amount
    * @param token: token address to be distributed
    * @param to: to address
    * @param amount: total amount of distribute
    * @param incentiveAmount: amount of incentive reward
    * @param parentAmount: amount of parent reward
    * @param grandpaAmount: amount of grandpa reward
    * @return distributedAmount : distributed token amount
    */
    function distribute(
        address token,
        address to,
        uint256 amount,
        uint256 incentiveAmount,
        uint256 parentAmount,
        uint256 grandpaAmount
    ) external returns(uint256 distributedAmount);

    /**
     * @dev query call add relation rewards amount 
     * @return add relation rewards amount 
     */
    function bindReward() external view returns(uint256);

    /**
     * @dev query remaining rewards amount
     * @return remaining rewards amount
     */
    function remainingRewards() external view returns(uint256);

    /**
     * @dev query total minted rewards amount
     * @return total minted rewards amount
     */
    function mintedRewards() external view returns(uint256);
    
    //an event thats emitted when new relation added
    event AddedRelation(address child,address parent);

    //an event thats emitted when token distributed
    event Distributed(address sender,address token, address to,uint256 toAmount,address parent, uint256 parantAmount,address grandpa, uint256 grandpaAmount);
}