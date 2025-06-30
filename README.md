# BioCredit - Biodiversity Conservation Credits System

A blockchain-based biodiversity conservation credits and ecosystem protection rewards platform built on Stacks, incentivizing habitat preservation and species protection through transparent tracking.

## Overview

BioCredit enables conservationists and organizations to track their biodiversity conservation actions across approved habitat types while earning conservation credits based on their ecosystem protection contributions.

## Features

- Conservation action logging with habitat type verification
- Approved habitat type management system
- Biodiversity credit calculation and distribution
- Transparent conservation tracking and rewards
- Ecosystem guardian oversight and governance

## Smart Contract Functions

### Public Functions
- `establish-biodiversity-program`: Initialize biodiversity conservation program
- `approve-habitat-type`: Approve habitat types for conservation tracking
- `record-conservation-actions`: Record conservation actions with habitat type
- `distribute-biodiversity-credits`: Distribute biodiversity credits
- `claim-biodiversity-rewards`: Claim biodiversity conservation rewards

### Read-Only Functions
- `get-conservationist-actions`: Get conservationist's total actions
- `get-habitat-type`: Get conservationist's habitat type
- `get-total-conservation-actions`: Get total conservation actions
- `is-habitat-approved`: Check habitat type approval status

## Usage

Deploy the contract and initialize with an ecosystem guardian. Approve habitat types, then conservationists can record actions and claim credits based on their contributions.

## Security

- Ecosystem guardian authorization controls
- Habitat type approval system for verified tracking
- Input validation for all conservation action entries
- Action verification before credit distribution