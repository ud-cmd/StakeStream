;; Title: StakeStream: Tiered Staking & Governance Protocol
;; Summary: A next-generation decentralized protocol combining yield generation, governance voting, and data analytics incentives on Stacks L2
;; Description: StakeStream revolutionizes decentralized finance on Bitcoin through:
;; - Tiered staking system with multiplier rewards (Bronze/Silver/Gold tiers)
;; - On-chain governance powered by staked STX voting power
;; - Time-locked staking bonuses with cooldown security mechanisms
;; - Native analytics token incentives for protocol engagement
;; - Fully transparent reward calculations with emergency fallback modes
;; Built natively on Stacks L2 for Bitcoin-finalized transactions, offering:
;; - Secure STX staking with flexible lock-up periods
;; - Governance-controlled protocol parameters
;; - Compliance-focused architecture with configurable safeguards
;; - Real-time position health monitoring and risk management

;; Core smart contract implementing StakeStream protocol mechanics including:
;; - Dynamic reward distribution with tier-based multipliers
;; - Proposal-based governance system with voting power scaling
;; - STX staking pool management with Bitcoin-settled security
;; - Analytics token integration for ecosystem participation
;; - Emergency state machine for protocol protection

;; Token Definitions
(define-fungible-token ANALYTICS-TOKEN u0)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-PROTOCOL (err u1001))
(define-constant ERR-INVALID-AMOUNT (err u1002))
(define-constant ERR-INSUFFICIENT-STX (err u1003))
(define-constant ERR-COOLDOWN-ACTIVE (err u1004))
(define-constant ERR-NO-STAKE (err u1005))
(define-constant ERR-BELOW-MINIMUM (err u1006))
(define-constant ERR-PAUSED (err u1007))

;; Protocol Configuration
(define-data-var contract-paused bool false)
(define-data-var emergency-mode bool false)
(define-data-var stx-pool uint u0)
(define-data-var base-reward-rate uint u500) ;; 5% base rate (100 = 1%)
(define-data-var bonus-rate uint u100) ;; 1% bonus for longer staking
(define-data-var minimum-stake uint u1000000) ;; Minimum stake amount
(define-data-var cooldown-period uint u1440) ;; 24 hour cooldown in blocks
(define-data-var proposal-count uint u0)

;; Data Maps
(define-map Proposals
    { proposal-id: uint }
    {
        creator: principal,
        description: (string-utf8 256),
        start-block: uint,
        end-block: uint,
        executed: bool,
        votes-for: uint,
        votes-against: uint,
        minimum-votes: uint
    }
)