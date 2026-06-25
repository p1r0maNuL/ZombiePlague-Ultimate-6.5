# Zombie Plague Ultimate 6.5 🧟

> A comprehensive, feature-rich Half-Life: Counter-Strike Zombie Plague mod with 48 classes, VIP system, achievements, game modes, events, and more!

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Commands](#commands)
- [Game Modes](#game-modes)
- [Classes](#classes)
- [VIP System](#vip-system)
- [Achievements](#achievements)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)

---

## 🎮 Overview

**Zombie Plague Ultimate 6.5** is the most advanced zombie mod for Half-Life: Counter-Strike. It features:

- **48 Custom Classes** (24 Zombie + 24 Human)
- **5 Game Modes** with unique mechanics
- **5 VIP Tiers** with exclusive benefits
- **50+ Achievements** with rewards
- **10+ Special Events** (Halloween, Christmas, etc.)
- **4 Seasonal Systems** with bonuses
- **Admin Tools** with anti-cheat system
- **Leaderboards** and player rankings
- **Full customization** via config files

---

## ✨ Features

### 🧟 Zombie Classes (24)

**Tier 1 (Free)**
- Classic Zombie
- Soldier Zombie
- Assassin Zombie
- Heavy Zombie
- Runner Zombie
- Tank Zombie

**Tier 2 (Intermediate)**
- Venom Zombie
- Parasite Zombie
- Nightmare Zombie
- Demon Zombie
- Ghoul Zombie
- Mutant Zombie

**Tier 3 (Advanced)**
- Shadow Zombie
- Werewolf Zombie
- Vampire Zombie
- Phoenix Zombie
- Cyber Zombie
- Dragon Zombie

**Tier 4 (Elite)**
- Nemesis Zombie
- Plague Zombie
- Leviathan Zombie
- Reaper Zombie
- God Zombie
- Apocalypse Zombie

### 👨 Human Classes (24)

**Tier 1 (Free)**
- Light Infantry
- Combat Soldier
- Scout
- Gunner
- Sniper
- Support

**Tier 2 (Intermediate)**
- Special Forces
- Commando
- Ranger
- Heavy Gunner
- Marksman
- Medic

**Tier 3 (Advanced)**
- Elite Operative
- Tactician
- Assassin
- Tank Trooper
- Master Sniper
- Field Medic

**Tier 4 (Elite)**
- Black Ops
- Commander
- Apex Predator
- Goliath
- Phantom Sniper
- Chief Medic

### 🎮 Game Modes (5)

1. **Infection Mode** - One zombie infects humans
2. **Survivor Mode** - Fixed zombies vs. humans
3. **Nemesis Mode** - One powerful zombie vs. many humans
4. **Swarm Mode** - Progressive zombie waves
5. **Plague Mode** - Fast-spreading plague zombies

### 🎁 VIP System (5 Tiers)

| Tier | Price | Duration | XP | Credits | HP | Speed |
|------|-------|----------|-----|---------|-------|-------|
| VIP 1 | $5K | 30d | +10% | +10% | +100 | +50 |
| VIP 2 | $15K | 30d | +20% | +20% | +200 | +100 |
| VIP 3 | $30K | 30d | +30% | +30% | +300 | +150 |
| VIP 4 | $50K | 30d | +40% | +40% | +400 | +200 |
| VIP 5 | $100K | 30d | +50% | +50% | +500 | +250 |

### 🏆 Achievements (50+)

**Categories:**
- Kills (5 achievements)
- Headshots (3 achievements)
- Infection (3 achievements)
- Survival (4 achievements)
- Damage (4 achievements)
- XP/Level (4 achievements)
- Credits (3 achievements)
- Classes (3 achievements)
- VIP (3 achievements)
- Speed (3 achievements)
- Game Modes (4 achievements)
- Playtime (5 achievements)
- Special (5 achievements)

### 📅 Events & Seasons

**10+ Events:**
- Double XP Weekend
- Triple Credits
- Halloween (Oct 1-31)
- Christmas (Dec 15-31)
- New Year (Jan 1-7)
- Summer Madness (Jun-Aug)
- Easter Hunt (Spring)
- Anniversary Bash (May 15-22)
- VIP Week (Monthly)
- Speedrun Challenge (Weekly)

**4 Seasons:**
- Spring (Nature theme, +100% XP)
- Summer (Heat theme, +150% XP)
- Autumn (Harvest theme, +120% XP)
- Winter (Cold theme, +130% XP)

---

## 📦 Installation

### Requirements
- Half-Life: Counter-Strike server
- AMXModX 1.10+
- MetaMod

### Step 1: Extract Files

```bash
cd /path/to/cstrike/
unzip zombie-plague-ultimate-6.5.zip
```

Files will be placed in:
```
cstrike/
├── addons/amxmodx/
│   ├── plugins/
│   │   ├── zp_core.amxx
│   │   ├── zp_classes.amxx
│   │   ├── zp_vip_system.amxx
│   │   ├── zp_achievements.amxx
│   │   ├── zp_leaderboard.amxx
│   │   ├── zp_admin_tools.amxx
│   │   ├── zp_anticheat.amxx
│   │   ├── zp_game_modes.amxx
│   │   ├── zp_mode_features.amxx
│   │   ├── zp_events_seasonal.amxx
│   │   └── zp_special_events.amxx
│   └── configs/
│       └── zp_config.ini
├── configs/
│   └── zp_vip.ini
│   └── zp_classes.ini
│   └── zp_events.ini
└── sound/
    └── zombie_plague/
        └── [sound files]
```

### Step 2: Configure

Edit `addons/amxmodx/configs/plugins.ini` and add:

```ini
; Zombie Plague Ultimate
zp_core.amxx
zp_classes.amxx
zp_vip_system.amxx
zp_achievements.amxx
zp_leaderboard.amxx
zp_admin_tools.amxx
zp_anticheat.amxx
zp_game_modes.amxx
zp_mode_features.amxx
zp_events_seasonal.amxx
zp_special_events.amxx
```

### Step 3: Restart Server

```bash
./restart.sh
# or
rcon restart
```

### Step 4: Verify Installation

In-game, type: `/info` or `/help`

You should see Zombie Plague commands listed.

---

## ⚙️ Configuration

### Main Config: `zp_config.ini`

```ini
// Enable/disable features
zp_enabled 1
zp_classes_enabled 1
zp_vip_enabled 1
zp_achievements_enabled 1
zp_events_enabled 1
zp_anticheat_enabled 1

// Gameplay settings
zp_start_zombie_count 1
zp_zombie_health_multiplier 1.0
zp_human_health_multiplier 1.0
zp_xp_multiplier 1.0
zp_credits_multiplier 1.0

// VIP settings
zp_vip_xp_bonus_mult 1.5
zp_vip_credits_bonus_mult 1.5

// Anti-cheat thresholds
zp_max_speed_per_second 10000
zp_max_xp_per_round 5000
zp_max_credits_per_round 5000
```

### VIP Config: `zp_vip.ini`

Customize VIP tier prices, bonuses, and durations.

### Class Config: `zp_classes.ini`

Customize class stats, models, and abilities.

---

## 🎮 Commands

### Player Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `/classes` | `/classes` | Show available classes |
| `/selectclass` | `/selectclass <id>` | Select a class |
| `/info` | `/info` | Show plugin information |
| `/vip` | `/vip` | Show VIP info |
| `/buyvip` | `/buyvip` | Open VIP shop |
| `/achievements` | `/achievements` | Show achievements |
| `/leaderboard` | `/leaderboard` | Top 10 players |
| `/stats` | `/stats` | Personal statistics |
| `/events` | `/events` | Show active events |
| `/season` | `/season` | Show current season |
| `/modes` | `/modes` | Show game modes |

### Admin Commands

| Command | Level | Usage | Description |
|---------|-------|-------|-------------|
| `amx_givexp` | ADMIN | `amx_givexp <player> <xp>` | Award XP |
| `amx_givecredits` | ADMIN | `amx_givecredits <player> <amount>` | Award credits |
| `amx_slay` | ADMIN | `amx_slay <player>` | Slay player |
| `amx_freeze` | MOD | `amx_freeze <player>` | Freeze player |
| `amx_mute` | MOD | `amx_mute <player>` | Mute player |
| `amx_setvip` | OWNER | `amx_setvip <player> <tier>` | Set VIP tier |
| `amx_setlevel` | OWNER | `amx_setlevel <player> <level>` | Set level |
| `amx_ban` | OWNER | `amx_ban <player>` | Ban player |
| `amx_adminlog` | ADMIN | `amx_adminlog` | View admin log |

---

## 🎮 Game Modes

### 1. Infection Mode

**Objective:** Zombies infect all humans

- 1 zombie starts each round
- Infected humans become zombies
- Humans win if they survive
- Zombies win if they infect all

**Commands:**
```
/modevote 1 - Vote for Infection
```

### 2. Survivor Mode

**Objective:** Humans survive fixed zombie count

- 3 fixed zombies per round
- Zombie count stays constant
- Respawning zombies if killed
- Humans must last to end of round

### 3. Nemesis Mode

**Objective:** Defeat the Nemesis

- 1 powerful Nemesis zombie (5000 HP)
- Nemesis has special abilities
- Humans must work together
- More challenging than other modes

### 4. Swarm Mode

**Objective:** Survive progressive waves

- Waves increase each round
- Wave 1: 5 zombies → Wave 10: 25 zombies
- Zombies get stronger each wave
- Last as long as possible

### 5. Plague Mode

**Objective:** Stop the plague spread

- 2 Plague zombies start
- Plague spreads faster (150%)
- Plague zombies regenerate
- Infection chains rapidly

---

## 🏆 Achievement System

### How to Earn Achievements

1. **Unlock Conditions** - Complete achievement objectives
2. **Notification** - Get center message when unlocked
3. **Rewards** - Earn XP and credits
4. **Tracking** - View progress with `/achievements`

### Example Achievements

- **First Blood** - Get your first kill (+50 XP, +100 Credits)
- **Killer** - Get 10 kills (+100 XP, +200 Credits)
- **Legendary** - Get 500 kills (+500 XP, +1000 Credits)
- **Sharpshooter** - Get 5 headshots (+75 XP, +150 Credits)
- **Survivor** - Survive 1 round (+50 XP, +100 Credits)
- **Immortal** - Survive 25 rounds (+400 XP, +800 Credits)

---

## 🔧 Troubleshooting

### Plugin Not Loading

**Problem:** Plugins fail to load

**Solution:**
1. Check `addons/amxmodx/logs/error.log`
2. Verify all script files are in `plugins/` directory
3. Ensure file permissions are correct (755)
4. Restart server: `rcon restart`

### Classes Not Showing

**Problem:** `/classes` shows no classes

**Solution:**
1. Verify `zp_classes.ini` exists
2. Check `zp_classes.amxx` is loaded: `amx_plugins`
3. Ensure config file syntax is correct

### VIP Not Working

**Problem:** VIP commands don't work

**Solution:**
1. Verify `zp_vip_system.amxx` is loaded
2. Check player has enough credits: `/stats`
3. Try `/vipshop` instead of `/buyvip`
4. Check server log for errors

### Anti-Cheat False Positives

**Problem:** Legitimate players getting warnings

**Solution:**
1. Adjust thresholds in `zp_config.ini`:
   - Increase `zp_max_speed_per_second`
   - Increase `zp_max_xp_per_round`
2. Check for lag/ping issues
3. Whitelist trusted players: `amx_whitelist <player>`

### Performance Issues

**Problem:** Server lagging/high CPU

**Solution:**
1. Disable unused plugins in `plugins.ini`
2. Reduce player limits
3. Lower sound quality in configs
4. Check server resources: `htop`

---

## 📊 Stats & Metrics

### Player Progression

- **Levels:** 1-100
- **XP:** Required for levels
- **Credits:** Earned through gameplay
- **Achievements:** 50+ total
- **Playtime:** Tracked globally

### Server Statistics

- **Total Rounds Played:** Tracked
- **Total Kills:** Global counter
- **Most Popular Mode:** Tracked
- **Top Player:** Leaderboard
- **Active Events:** Real-time display

---

## 📝 Configuration Examples

### Reduce VIP Prices

Edit `configs/zp_vip.ini`:

```ini
zp_vip1_price 2000          ; VIP 1 now $2000
zp_vip2_price 5000          ; VIP 2 now $5000
zp_vip3_price 10000         ; VIP 3 now $10000
```

### Increase XP Gain

Edit `zp_config.ini`:

```ini
zp_xp_multiplier 2.0        ; 2x XP from gameplay
```

### Custom Anti-Cheat

Edit `zp_config.ini`:

```ini
zp_max_speed_per_second 15000  ; More lenient speed
zp_max_xp_per_round 10000      ; More generous XP
```

---

## 🚀 Performance Optimization

### Server Resources

- **CPU Usage:** ~5-10% (depends on player count)
- **Memory:** ~50-100 MB
- **Network:** ~2-5 Mbps (depends on tickrate)

### Optimization Tips

1. **Reduce Tick Rate** - Lower from 100 to 66
2. **Disable Sounds** - Remove optional sounds
3. **Limit Particles** - Reduce visual effects
4. **Close Unused Ports** - Security & performance

---

## 🐛 Known Issues

### Issue: Achievement not unlocking

**Status:** Fixed in 6.5

**Workaround:** Restart plugin

### Issue: VIP benefits not applying

**Status:** Fixed in 6.5

**Workaround:** Rejoin server

### Issue: Anti-cheat too strict

**Status:** Known, adjust thresholds in config

**Workaround:** Increase limits in `zp_config.ini`

---

## 📞 Support

### Getting Help

- **Discord:** [Join Server]
- **Forum:** [Zombie Plague Forums]
- **GitHub Issues:** [Report Bug]
- **Email:** support@zombieplague.net

### Reporting Bugs

Include:
1. Server version and OS
2. AMXModX version
3. Error log snippets
4. Steps to reproduce

---

## 🎓 For Developers

### Extending the Mod

The mod is fully modular. Create new modules:

1. Create `scripting/zp_mymodule.sma`
2. Include `include/zombie_plague.inc`
3. Implement native functions
4. Compile to `plugins/zp_mymodule.amxx`
5. Add to `plugins.ini`

### Example Custom Module

```amx
#include <amxmodx>
#include "include/zombie_plague.inc"

public plugin_init() {
    register_plugin("My ZP Module", "1.0", "Your Name");
    register_concmd("say /mycommand", "cmd_mycommand");
}

public cmd_mycommand(id) {
    client_print(id, print_chat, "Hello from my module!");
    return PLUGIN_HANDLED;
}
```

---

## 📄 License

**Zombie Plague Ultimate 6.5**

Copyright © 2026 p1r0maNuL

All rights reserved. This mod is provided as-is for private use.

---

## 🙏 Credits

**Development Team:**
- p1r0maNuL - Lead Developer

**Special Thanks:**
- AMXModX Community
- Half-Life Modding Community
- All Players & Testers

---

## 📝 Changelog

### Version 6.5 (Final Release - June 2026)

✅ Phase 1: Core System (Round, Team, Zombie mechanics)
✅ Phase 2: Classes (48 total classes)
✅ Phase 3: Leveling & Progression (100 levels)
✅ Phase 4: Shop & Weapons System
✅ Phase 5: VIP System (5 tiers)
✅ Phase 6: Achievements & Leaderboard (50+ achievements)
✅ Phase 7: Admin Tools & Anti-Cheat
✅ Phase 8: Game Modes (5 modes)
✅ Phase 9: Events & Seasonal System (10+ events)
✅ Phase 10: Final Polish & Documentation

---

**Enjoy Zombie Plague Ultimate 6.5! 🧟**

For the latest updates, visit: https://github.com/p1r0maNuL/ZombiePlague-Ultimate-6.5
