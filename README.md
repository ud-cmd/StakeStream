# StakeStream Protocol: Tiered Staking & Governance Smart Contract

## Overview

StakeStream is an advanced DeFi protocol built on Stacks L2 that combines yield generation, decentralized governance, and ecosystem incentives through three core pillars:

1. **Tiered STX Staking**: Earn compounding rewards scaled by stake size and lock-up periods
2. **On-Chain Governance**: Direct protocol evolution using stake-based voting power
3. **Analytics Incentivization**: Earn ecosystem tokens for participation and data contributions

Designed for Bitcoin-native DeFi, this contract implements enterprise-grade features including time-locked staking positions, emergency circuit breakers, and multi-tier reward architectures.

---

## Key Features

### 1. Dynamic Tier System

| Tier   | Minimum STX | Multiplier | Features Enabled                             |
| ------ | ----------- | ---------- | -------------------------------------------- |
| Bronze | 1M uSTX     | 1x         | Basic staking, governance voting             |
| Silver | 5M uSTX     | 1.5x       | Extended lock periods, premium analytics     |
| Gold   | 10M uSTX    | 2x         | Protocol fee sharing, governance veto rights |

### 2. Adaptive Reward Engine

- **Base Rate**: 5% APY (adjustable via governance)
- **Lock Multipliers**:
  - 1 month lock: +25% APR boost
  - 2 month lock: +50% APR boost
- **Tier Multipliers**: 1-2x scaling

```clarity
Rewards = (Staked Amount × Base Rate × Tier Multiplier × Lock Multiplier × Blocks Staked) / 14400000
```

### 3. Governance Machinery

- Proposal creation requires ≥1M voting power
- Voting periods: 100-2880 blocks (≈1hr-24hrs)
- Quadratic voting weights with minimum quorum

### 4. Enterprise Security

- 24-hour unstaking cooldown
- Owner-initiated emergency pauses
- Bitcoin-block anchored time locks
- Position health monitoring system

---

## Technical Architecture

### Core Data Structures

```clarity
;; Tier Configuration
TierLevels: {
  minimum-stake: uint,
  reward-multiplier: uint,
  features-enabled: [bool; 10]
}

;; User Position
UserPosition: {
  stx-staked: uint,
  analytics-tokens: uint,
  voting-power: uint,
  tier-level: uint,
  rewards-multiplier: uint
}

;; Staking Position
StakingPosition: {
  amount: uint,
  start-block: uint,
  lock-period: uint,
  cooldown-start: optional<uint>
}
```

---

## Core Functionality

### Staking Operations

1. **Stake STX**  
   `(stake-stx @amount @lock-period)`

   - Requires ≥1M uSTX
   - Lock periods: 0 (flexible), 4320 (1mo), 8640 (2mo)
   - Auto-upgrades tier status

2. **Initiate Unstaking**  
   `(initiate-unstake @amount)`

   - Triggers 24h cooldown
   - Partial unstaking allowed

3. **Complete Unstaking**  
   `(complete-unstake)`
   - After cooldown expires
   - Full principal return

### Governance Engine

1. **Proposal Creation**  
   `(create-proposal @description @voting-period)`

   - 256-character description limit
   - Enforces minimum voting power

2. **Voting**  
   `(vote-on-proposal @proposal-id @vote-for)`
   - 1 STX = 1 voting power
   - Irrevocable votes

### Protocol Management

- `(pause-contract)`: Freezes non-essential operations
- `(resume-contract)`: Restores full functionality
- `(initialize-contract)`: Owner-only setup

---

## Security Model

### Fail-Safe Mechanisms

- **Cooldown Enforcement**: 1440-block delay on unstaking
- **Emergency Toggle**: Instant protocol freeze
- **Input Validation**:
  ```clarity
  (asserts! (is-valid-lock-period lock-period) ERR-INVALID-PROTOCOL)
  (asserts! (>= amount (var-get minimum-stake)) ERR-BELOW-MINIMUM)
  ```
- **State Machine Checks**: 17 unique error codes

---

## Installation & Usage

### Requirements

- Clarinet v1.5.0+
- Stacks Node v3.0
- Node.js 18+

### Deployment

```bash
clarinet contract publish stake-stream
```

### Sample Interaction

```clarity
;; Stake 5M uSTX for 1 month
(contract-call? .stake-stream stake-stx u5000000 u4320)

;; Create governance proposal
(contract-call? .stake-stream create-proposal "Upgrade reward rate" u1440)

;; Vote on proposal 42
(contract-call? .stake-stream vote-on-proposal u42 true)
```
