# Rlink开发文档
## 引入说明
    import 'IRlinkRelation.sol'
## functions
### **monthScale**
- 查询一个月等于多少秒
#### Parameters
- none
#### Returns
- `uint256` - 一个月的秒数
<h1></h1>

### **stakeBase**
- 查询需质押数量的计算基数
- 需质押数量计算公式
        
        //已使用月份数等于1时，需质押数量等于计算基数
        //已使用月份数大于1时，需质押数量通过以下公式计算
        (1 + 已使用月份数) * 已使用月份数 / 2 * 计算基数
#### Parameters
- none
#### Returns
- `uint256` - 需质押数量的计算基数
<h1></h1>

### **maxStakeMonth**
- 查询最高可质押月份数，达到此月份数视为长期可用
#### Parameters
- none
#### Returns
- `uint256` - 最高可质押月份数
<h1></h1>

### **maxStakeAmount**
- 查询最大可质押数量，当质押达到此数量时视为长期可用
#### Parameters
- none
#### Returns
- `uint256` - 最大可质押数量
<h1></h1>

### **globalTrial**
- 查询全局试用时间，单位：秒
#### Parameters
- none
#### Returns
- `uint256` - 全局试用时间
<h1></h1>

### **stakeEnabled**
- 查询质押开启状态
#### Parameters
- none
#### Returns
- `bool` - 质押开启状态
<h1></h1>

### **withdrawEnabled**
- 查询是否允许赎回质押
#### Parameters
- none
#### Returns
- `bool` - 是否允许赎回质押
<h1></h1>

### **burnEnabled**
- 查询是否允许销毁过期质押
#### Parameters
- none
#### Returns
- `bool` - 是否允许销毁过期质押
<h1></h1>

### **stakingToken**
- 查询质押代币(RLT)地址
#### Parameters
- none
#### Returns
- `address` - 质押代币(RLT)地址
<h1></h1>

### **addRelation**
- 添加邀请关系
- 要求`_child`必须是此tx的发起者
- 要求`_child`不可等于`_parent`或`_parent`的父级
#### Parameters
- `_child|address` - 子级地址
- `_parent|address` - 父级地址
#### Returns
- `bool` - 是否添加成功
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

### **stake**
- 质押RLT
#### Parameters
- `forAccount|address` - 为哪个合约地址质押
- `amount|address` - 质押数量
#### Returns
- `bool` - 是否质押成功
<h1></h1>

### **stakeOf**
- 查询指定地址的已质押数量
#### Parameters
- `account|address` - 要查询的地址
#### Returns
- `uint256` - 已质押数量
<h1></h1>

### **withdraw**
- 赎回质押（仅在RlinkRelation合约开启允许赎回时可用）
#### Parameters
- `to|address` - 赎回到的地址
#### Returns
- none
<h1></h1>

### **burnExpiredStake**
- 销毁过期质押（仅在RlinkRelation合约开启允许销毁过期质押时可用）
#### Parameters
- `account|address` - 要销毁的过期质押所属地址
#### Returns
- none
<h1></h1>

### **distribute**
- 分发代币
- require `incentiveRate` + `parentRate` + `grandpaRate` 小于1e18
#### Parameters
- `token|address` - 要分发的代币地址
- `to|address` - 本次分发的主要收币地址
- `amount|uint256` - 分发数量
- `incentiveRate|uint256` - 邀请激励比例的分子（分母为1e18），有父级时，`to`才能拿到此奖励，可传0
- `parentRate|uint256` - 父级奖励比例的分子（分母为1e18），可传0
- `grandpaRate|uint256` - 父级的父级奖励比例的分子（分母为1e18），可传0
#### Returns
- `distributedAmount|uint256` - 本次分发总共打出去的`token`数量
<h1></h1>

### **trialExpireAt**
- 查询指定地址试用期截止时间
#### Parameters
- `account|address` - 要查询的地址
#### Returns
- `uint256` - 试用期截止时间
<h1></h1>

### **expireAt**
- 查询指定地址调用分发接口的有效期截止时间
#### Parameters
- `account|address` - 要查询的地址
#### Returns
- `uint256` - 调用分发接口的有效期截止时间
<h1></h1>

### **distributeFee**
- 查询调用分发接口的单次收费数量（当前为0）
#### Parameters
- none
#### Returns
- `uint256` - 调用分发接口的单次收费数量
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

### 附IRlinkRelaton.sol
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