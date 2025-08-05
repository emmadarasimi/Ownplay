# Ownplay

A blockchain-powered platform that gives gamers true ownership of their in-game items — enabling players to buy, sell, trade, and carry their assets across games using NFTs.

---

## Overview

Ownplay is built on the Stacks blockchain and consists of 9 smart contracts that work together to create a secure, modular, and extensible ecosystem for managing in-game assets and their utility:

1. **Item NFT Contract** – Mints, transfers, and tracks unique in-game items.
2. **Game Registry Contract** – Registers approved games that can interpret Ownplay NFTs.
3. **Inventory Contract** – Manages per-player loadouts, slots, and equipped items.
4. **Rental Contract** – Enables time-bound renting of NFTs to other players.
5. **Trading Hub Contract** – A decentralized marketplace for listing, buying, and exchanging in-game items.
6. **Crafting Contract** – Combines multiple NFTs into upgraded or rare versions.
7. **Access Control Contract** – Manages developer roles, asset creators, and permission scopes.
8. **Royalty Engine Contract** – Automatically distributes royalties on secondary sales to original creators.
9. **Intergame Bridge Contract** – Facilitates asset migration and interpretation across multiple games.

---

## Features

- **NFT-powered ownership** of all in-game assets  
- **Cross-game interoperability** via registered game modules  
- **Player inventory system** with equipped/unequipped state tracking  
- **Item rentals** with time-locked smart contracts  
- **Decentralized item marketplace** with native trading  
- **Crafting and upgrades** of NFT-based gear  
- **Royalty system** for item creators  
- **Developer access management** for game integrations  
- **Secure asset bridging** across supported games  

---

## Smart Contracts

### Item NFT Contract
- Mint and burn unique item NFTs
- Support for item metadata and rarity tiers
- Enforce ownership transfer rules

### Game Registry Contract
- Register verified games
- Associate game metadata and permissions
- Gate asset utility access per game

### Inventory Contract
- Assign NFTs to inventory slots
- Equip/unequip logic
- Inventory size rules and item type validation

### Rental Contract
- Create rental offers for NFTs
- Time-locked return mechanism
- Option for buyout or renewal

### Trading Hub Contract
- List NFTs for sale or swap
- Buy, bid, and delist mechanisms
- Escrow-based transfers for secure trades

### Crafting Contract
- Burn multiple NFTs to mint new items
- Recipes and upgrade tiers
- Success/failure mechanics (optional)

### Access Control Contract
- Developer and creator role management
- Permission levels for contract interaction
- Verification for game integrations

### Royalty Engine Contract
- On-chain royalty registry
- Splits resale revenue to original creators
- Auto-disbursal via contract calls

### Intergame Bridge Contract
- Validate and map asset utility across games
- Game-specific interpretation of item attributes
- Transfer logs and compatibility checks

---

## Installation

1. Install [Clarinet CLI](https://docs.hiro.so/clarinet/getting-started)
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ownplay.git
    ```
3. Run tests:
    ```bash
    npm test
    ```
4. Deploy contracts:
    ```bash
    clarinet deploy
    ```

---

## Usage

Each smart contract in Ownplay is modular and permissioned, but collectively they power a robust NFT-based asset management layer for game developers and players.

Refer to individual contract documentation for function signatures, expected parameters, and integration examples.

---

## License

MIT License
