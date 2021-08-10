# Rlink development document
## instructions
    import 'IRlinkRelation.sol'
## functions
### **monthScale**
- Returns how many seconds a month equals
#### Parameters
- none
#### Returns
- `uint256` - Seconds of a month
<h1></h1>

### **stakeBase**
- Query the calculation base of the quantity to be pledged -

- formula for calculating the quantity to be pledged
          

        //When the number of used months is equal to 1, the quantity to be pledged is equal to the calculation base
        //When the number of used months is greater than 1, the quantity to be pledged is calculated by the following formula
        (1+used months) * used months/2 * calculation base
#### Parameters
- none
#### Returns
- `uint256` - Calculation base of quantity to be pledged
<h1></h1>

### **maxStakeMonth**
- Query the maximum number of months that can be pledged. If the number reaches this number, it will be regarded as long-term availability
#### Parameters
- none
#### Returns
- `uint256` - Maximum number of pledge months
<h1></h1>

### **maxStakeAmount**
- Query the maximum quantity that can be pledged. When the pledge reaches this quantity, it is considered as long-term availability
#### Parameters
- none
#### Returns
- `uint256` - Maximum quantity that can be pledged
<h1></h1>

### **globalTrial**
- Query global trial time ，unit：second
#### Parameters
- none
#### Returns
- `uint256` - Global trial time
<h1></h1>

### **stakeEnabled**
- Query the opening status of pledge
#### Parameters
- none
#### Returns
- `bool` - Pledge open status
<h1></h1>

### **withdrawEnabled**
- Query whether to allow redemption of pledge
#### Parameters
- none
#### Returns
- `bool` - Is it allowed to redeem the pledge
<h1></h1>

### **burnEnabled**
- Query whether the expired pledge is allowed to be destroyed
#### Parameters
- none
#### Returns
- `bool` - Is it allowed to destroy the expired pledge
<h1></h1>

### **stakingToken**
- Query pledged token (RLT) address
#### Parameters
- none
#### Returns
- `address` - Pledged token (RLT) address
<h1></h1>

### **addRelation**
- Add reference relationship
- Require `_child` must be tx sender
- RRequire that '_child' cannot be equal to '_parent' or the parent of '_parent'
#### Parameters
- `_child|address` - Child address
- `_parent|address` - Parent address
#### Returns
- `bool` - Whether to add successfully or not
<h1></h1>

### **isParent**
- Query child and parent is associated
#### Parameters
- `child|address` - Child address
- `parent|address` - Parent Address
#### Returns
- `bool` - Whether or not associated
<h1></h1>

### **parentOf**
- Query the parent of the specified address
#### Parameters
- `account|address` - Address to query
#### Returns
- `address` - Parent address
<h1></h1>

### **stake**
- staking RLT
#### Parameters
- `forAccount|address` - Staking for which contract address
- `amount|address` - Staking number
#### Returns
- `bool` - Whether to stake successfully or not
<h1></h1>

### **stakeOf**
- Query the staked quantity at the specified address
#### Parameters
- `account|address` - The Address to query
#### Returns
- `uint256` - Staked number
<h1></h1>

### **withdraw**
- Redemption staking tokens (available only when the RlinkRelation contract is opened to allow redemption)
#### Parameters
- `to|address` - Redeemed address
#### Returns
- none
<h1></h1>

### **burnExpiredStake**
- Destroy expired pledge (only available when the RlinkRelation contract is opened to allow the destruction of expired pledge)
#### Parameters
- `account|address` -Address of expired staking tokens to be destroyed
#### Returns
- none
<h1></h1>

### **distribute**
- Distribute tokens
- Require `incentiveRate` + `parentRate` + `grandpaRate` Less than 1e18
#### Parameters
- `token|address` - The address of token to be distributed
- `to|address` - The main receiving address of this distribution
- `amount|uint256` - Distribution quantity
- `incentiveRate|uint256` - the numerator (denominator is 1e18) of the invitation incentive proportion. When there is a parent, `to' can get this award, which can be passed to 0
- `parentRate|uint256` - The numerator of the parent award proportion (denominator is 1e18), which can be passed to 0
- `grandpaRate|uint256` - The numerator (denominator is 1e18) of the parent reward ratio of the parent, which can be passed as 0
#### Returns
- `distributedAmount|uint256` - Total number of token' typed out in this distribution
<h1></h1>

### **trialExpireAt**
- Query the probation period end time of the specified address
#### Parameters
- `account|address` - address to query
#### Returns
- `uint256` - Trial period deadline
<h1></h1>

### **expireAt**
- Query the expiration time of calling the distribution interface at the specified address
#### Parameters
- `account|address` - The address to query
#### Returns
- `uint256` - Expiration time of calling distribution interface
<h1></h1>

### **distributeFee**
- Query the single charge quantity of calling distribution interface (currently 0)
#### Parameters
- none
#### Returns
- `uint256` - Number of single charges for calling distribution interface
<h1></h1>

### **bindReward**
- Query the number of rewards you can get when adding an invitation relationship
#### Parameters
- none
#### Returns
- `uint256` - Number of awards available
<h1></h1>

### **remainingRewards**
- Query the remaining quantity of prize pool for adding invitation relationship
#### Parameters
- none
#### Returns
- `uint256` - Remaining quantity of prize pool
<h1></h1>

### **mintedRewards**
- Query the total number of rewards dug up by adding invitation relationship
#### Parameters
- none
#### Returns
- `uint256` - Total rewards dug up cumulatively
<h1></h1>

## Contract addresses
### Ethereum mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0x2a520797D0864DCA9DB40f55869673355b13AF33 |
| Rlink Relation | 0xe3ae76Ad8Fd977ac540e1A67652fbA3E9b95f362 |

### Ethereum rinkeby
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x1979A18C6e736c7a9335514B503d875a7Fd22997 |
| Rlink Relation | 0xe9De97CF0e158315353E0bf7F8C49efc3D84BE16 |

### BSC mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0xBEF49A121aABC49Bfc53Bf60f80DF9d14fE32983 |
| Rlink Relation | 0x7c2e0a82B2d6e19C4cfAe0503e8750f9BC064f43 |

### BSC testnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x90Df661930f72b1c22545A29064C8b6189E6E82D |
| Rlink Relation | 0xd42f6F027Db115275a1548FB8a5B5aD02c1Bc37e |

### HECO mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0x31f3C732be59Fc4d7D884516F48e0E448669cCfa |
| Rlink Relation | 0x45Edbe0DB0528909BFdCBe4ACf793D92fd19C685 |

### HECO testnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x60E0aa878E0d4D63F98F3188c232443694114ca7 |
| Rlink Relation | 0x4837643E2F48ad61D8b4d7EE9FC60863b521b873 |


## Ref：IRlinkRelaton.sol
    // SPDX-License-Identifier: MIT

    pragma solidity ^0.8.0;

    interface IRlinkRelation {
        /**
        * @dev query seconds of a month
        * @return seconds of a month
        */
        function monthScale() external pure returns(uint256);

        /**
        * @dev query stake base amount,stake monthes formula: (1 + usingMonthes) * usingMonthes / 2 * stakeBase
        * @return stake base amount
        */
        function stakeBase() external pure returns(uint256);

        /**
        * @dev query stake for month limit
        * @return stake for month limit
        */
        function maxStakeMonth() external view returns(uint256);

        /**
        * @dev query staked limit
        * @return stake limit
        */
        function maxStakeAmount() external view returns(uint256);

        /**
        * @dev query global trial seconds
        * @return seconds of global trial
        */
        function globalTrial() external view returns(uint256);

        /**
        * @dev query stake enable status
        * @return stake enable status
        */
        function stakeEnabled() external view returns(bool);

        /**
        * @dev query withdraw enable status
        * @return withdraw enable status
        */
        function withdrawEnabled() external view returns(bool);

        /**
        * @dev query burn expired stake enable status
        * @return burn expired stake enable status
        */
        function burnEnabled() external view returns(bool);

        /**
        * @dev query stakingToken address
        * @return burn stakingToken address
        */
        function stakingToken() external view returns(address);    

        /**
        * @dev add address relation
        * @param _child: address of the child
        * @param _parent: address of the parent
        * @return whether or not the add relation succeeded
        */
        function addRelation(address _child, address _parent) external returns(bool);

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
        * @dev stake stakingToken to rlink relation
        * @param forAccount: address of stake for
        * @param amount: stake amount
        * @return whether or not the stake succeeded
        */
        function stake(address forAccount,uint256 amount) external returns(bool);

        /**
        * @dev query address staked amount
        * @param account: address of to be queried
        * @return staked amount
        */
        function stakeOf(address account) external view returns(uint256);

        /**
        * @dev withdraw stake
        * require withdraw is enabled
        * @param to: withdraw to address
        */
        function withdraw(address to) external;

        /**
        * @dev burn expired stake of account
        * require burn expired stake is enabled
        * @param account: address of expired stake
        */
        function burnExpiredStake(address account) external;

        /**
        * @dev distribute token
        * you must approve bigger than 'amount' allowance of token for rlink relation contract before call
        * @param token: token address to be distributed
        * @param to: to address
        * @param incentiveRate: numerator of incentive rate,denominator is 1e18
        * @param parentRate: numerator of parent rewards rate,denominator is 1e18
        * @param grandpaRate: numerator of grandpa rewards rate,denominator is 1e18
        */
        function distribute(
            address token,
            address to,
            uint256 amount,
            uint256 incentiveRate,
            uint256 parentRate,
            uint256 grandpaRate
        ) external returns(uint256 distributedAmount);

        /**
        * @dev query trial expire at 
        * require burn expired stake is enabled
        * @param account: the address of to be queried
        * @return trial expire at of queried address
        */
        function trialExpireAt(address account) external view returns(uint256);

        /**
        * @dev query expire at
        * require burn expired stake is enabled
        * @param account: the address of to be queried
        * @return expire at of queried address
        */
        function expireAt(address account) external view returns(uint256);

        /**
        * @dev query call function 'distribute' fee (default is 0)
        * @return call function 'distribute' fee
        */
        function distributeFee() external view returns(uint256);

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

        //an event thats emitted when staked
        event Staked(address forAccount,uint256 amount);

        //an event thats emitted when token distributed
        event Distributed(address sender,address token, address to,uint256 toAmount,uint256 parantAmount, uint256 grandpaAmount);
    }