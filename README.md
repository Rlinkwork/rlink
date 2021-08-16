# rlink
### Overview

Rlink is the world's first oracle that completely realizes decentralized recommendation relationship and rebate. Rlink want to realized the whole process of recording the reference relationship on the smart contract and making chain rebates according to the reference relationship. 

In the phase1,we need to develop this oracle and test this oracle in the test chain on the polkadot ecosystem. We also will launch this oracle in the parallel chain which is compatible with EVM to serve those dapp developers.

Rlink aims to become the parallel chain to record the relationship between addresses for the polkadot chain and all parallel chains in the future

### Core services
Invitation relationship: This module records the invitation relationship between all addresses using a Hash map, and provides the function of querying and writing the associated address of any address.  Realize infinite level address associated record.  
Distribution: This module provides the function of distributing tokens for DAPP. By calling this module, DAPP can easily realize the distribution of tokens to a specified address and its associated address at a specified rate.  Supports multi-level associated address distribution  
![architecture](https://raw.githubusercontent.com/Rlinknetwork/rlink/main/docs/architecture.png)
