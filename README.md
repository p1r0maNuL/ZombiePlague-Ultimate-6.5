# Zombie Plague Ultimate 6.5

**Advanced Zombie Plague Plugin for CS 1.6 - AMXModX**

## Overview

Zombie Plague Ultimate 6.5 is a comprehensive game mode plugin for Counter-Strike 1.6 featuring:

- 🧟 **24 Zombie Classes** with progressive unlock system
- 🛡️ **24 Human Classes** with unique abilities
- 💰 **XP + Credit Economy** (Level 1-100)
- 🎮 **10+ Game Modes** (Infection, Nemesis, Survivor, Sniper, Assassin, Swarm, Multiple Infection, Plague, Armageddon, Dragon)
- 👑 **VIP System** (Paid & Free) with exclusive benefits
- 🛍️ **Advanced Shop** system with 20+ items
- 📊 **SQL Database** for persistent player data
- 🎯 **Admin System** with advanced bans/gags
- 🎨 **Cosmetics** (Pets, Trails, Skins, Death Effects)

## Project Structure

```
ZombiePlague-Ultimate-6.5/
├── README.md
├── scripting/
│   ├── include/
│   │   ├── zombie_plague.inc           # Main constants & natives
│   │   ├── zp_gamemodes.inc            # Game modes definitions
│   │   ├── zp_classes.inc              # Classes data
│   │   └── zp_vip.inc                  # VIP system constants
│   │
│   └── zp_main.sma                     # Main plugin entry point
│   ├── zp_core_engine.sma              # Core game engine
│   ├── zp_gamemodes.sma                # Game mode system
│   ├── zp_classes.sma                  # Classes system
│   ├── zp_xp_system.sma                # XP & Levels
│   ├── zp_credits.sma                  # Credits economy
│   ├── zp_shop.sma                     # Shop system
│   ├── zp_vip.sma                      # VIP benefits
│   ├── zp_admin.sma                    # Admin commands
│   ├── zp_register.sma                 # Registration system
│   ├── zp_database.sma                 # SQL database handler
│   └── zp_cosmetics.sma                # Pets, trails, skins
│
├── configs/
│   ├── zp_config.ini                   # Main configuration
│   ├── zp_gamemodes.ini                # Game mode settings
│   ├── zp_classes.ini                  # Classes configuration
│   ├── zp_vip.ini                      # VIP settings & pricing
│   ├── zp_shop.ini                     # Shop items & prices
│   ├── zp_admin.ini                    # Admin settings
│   └── zp_database.ini                 # Database connection
│
├── sql/
│   ├── zp_database.sql                 # Database schema
│   └── zp_init.sql                     # Initial data
│
├── data/
│   ├── zp_bans.txt                     # Ban list
│   ├── zp_gags.txt                     # Gag list
│   └── zp_whitelist.txt                # Whitelist
│
└── docs/
    ├── INSTALLATION.md                 # Installation guide
    ├── CONFIGURATION.md                # Configuration guide
    ├── COMMANDS.md                     # Commands list
    ├── CLASSES.md                      # Classes documentation
    ├── GAMEMODES.md                    # Game modes documentation
    └── API.md                          # Plugin API for developers
```

## Installation

See [INSTALLATION.md](docs/INSTALLATION.md)

## Features

### Core Systems
- ✅ XP + Level Progression (1-100)
- ✅ Credit Economy
- ✅ SQL Database (persistent player data)
- ✅ VIP System (Paid & Free)
- ✅ Registration with password
- ✅ Admin system with logging

### Game Modes
- Infection
- Nemesis
- Survivor
- Sniper
- Assassin
- Swarm
- Multiple Infection
- Plague/Apocalypse
- Assassins vs Sniper
- Armageddon
- Dragon (NEW!)

### Classes (24 each for Zombie & Human)
- Progressive unlock system
- Stats scale with level
- Unique abilities per class

### VIP Benefits
- Triple Jump
- 100 Armor spawn
- Unlimited ammo
- No fall damage
- 1.5x damage multiplier
- Exclusive weapons
- Happy Hour bonuses

## Development Phases

- **Phase 1:** Core Engine (Game modes, zombie/human mechanics)
- **Phase 2:** XP + Levels
- **Phase 3:** Credits + Shop
- **Phase 4:** Classes System
- **Phase 5:** VIP System
- **Phase 6:** Admin + Registration
- **Phase 7:** Bonus Systems (Pets, Trails, Cosmetics)

## Requirements

- AMXModX 1.9.0+
- Metamod-r
- MySQL Server (for database)
- CS 1.6 Server

## License

MIT License - See LICENSE file

## Author

p1r0maNuL

## Support

For issues, questions, or suggestions, create an issue on GitHub.
