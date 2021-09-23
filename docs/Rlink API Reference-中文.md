# Rlink开发文档
## 引入说明
    import 'IRlinkRelation.sol'
## functions

### **addRelation**
- 添加邀请关系
- 要求`_child`必须是此tx的发起者
- 要求`_child`不可等于`_parent`或`_parent`的父级
#### Parameters
- `_child|address` - 子级地址
- `_parent|address` - 父级地址
#### Returns
- `uint256` - rlt奖励数量
<h1></h1>

### **isParent**
- 查询子级地址与父级地址是否已关联
#### Parameters
- `child|address` - 子级地址
- `parent|address` - 父级地址
#### Returns
- `bool` - 是否已关联
<h1></h1>

### **parentOf**
- 查询指定地址的父级
#### Parameters
- `account|address` - 要查询的地址
#### Returns
- `address` - 父级地址
<h1></h1>

### **distribute**
- 分发代币
- require `incentiveAmount` + `parentAmount` + `grandpaAmount` 小于 `amount`
#### Parameters
- `token|address` - 要分发的代币地址
- `to|address` - 本次分发的主要收币地址
- `amount|uint256` - 分发数量
- `incentiveAmount|uint256` - 邀请激励数量，有父级时，`to`才能拿到此奖励，可传0
- `parentAmount|uint256` - 父级奖励数量，可传0
- `grandpaAmount|uint256` - 父级的父级奖励数量，可传0
#### Returns
- `distributedAmount|uint256` - 本次分发总共打出去的`token`数量
<h1></h1>

### **bindReward**
- 查询添加邀请关系时可获得的奖励数量
#### Parameters
- none
#### Returns
- `uint256` - 可获得的奖励数量
<h1></h1>

### **remainingRewards**
- 查询添加邀请关系奖池剩余数量
#### Parameters
- none
#### Returns
- `uint256` - 奖池剩余数量
<h1></h1>

### **mintedRewards**
- 查询添加邀请关系累计挖出的奖励总数
#### Parameters
- none
#### Returns
- `uint256` - 累计挖出的奖励总数
<h1></h1>

## 合约地址
### Ethereum mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0x2a520797D0864DCA9DB40f55869673355b13AF33 |
| Rlink Relation | 0xe3ae76Ad8Fd977ac540e1A67652fbA3E9b95f362 |

### Ethereum rinkeby
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x1979A18C6e736c7a9335514B503d875a7Fd22997 |
| Rlink Relation | 0xA0028DF4decD523573B9cA520EB1539B92C81bdd |

### BSC mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0xBEF49A121aABC49Bfc53Bf60f80DF9d14fE32983 |
| Rlink Relation | 0x2fbb59aE194c9552d3bC4Aa168E9Ab684f579Fe6 |

### BSC testnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x90Df661930f72b1c22545A29064C8b6189E6E82D |
| Rlink Relation | 0x988258ead056CbF2d600F60F75dEa54441944f94 |

### HECO mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0x31f3C732be59Fc4d7D884516F48e0E448669cCfa |
| Rlink Relation | 0x9D382B29B3e8736493dE318424667F2Cf0B4252F |

### HECO testnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Test Rlink Token | 0x60E0aa878E0d4D63F98F3188c232443694114ca7 |
| Rlink Relation | 0x5CE6f9143Fb6E07a0c9fDCCE255b32Ad1f8FB617 |

### HSC mainnet
| Contract name | Contract address |
| -------------- | ---------------- |
| Rlink Token | 0x2a520797D0864DCA9DB40f55869673355b13AF33 |
| Rlink Relation | 0xd859DadF8f36b18195419215561498D6641Ae6a9 |

### 附IRlinkRelaton.sol
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