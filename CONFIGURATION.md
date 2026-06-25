# Zombie Plague Ultimate 6.5 - Configuration Guide

## 📋 Configuration Files

All configuration files are located in:
```
addons/amxmodx/configs/
```

---

## 🎮 Main Config: zp_config.ini

### General Settings

```ini
// ==================== GENERAL ====================

// Enable/disable entire Zombie Plague mod
zp_enabled 1

// Enable specific systems
zp_classes_enabled 1
zp_leveling_enabled 1
zp_vip_enabled 1
zp_achievements_enabled 1
zp_events_enabled 1
zp_anticheat_enabled 1
zp_admin_tools_enabled 1
```

### Gameplay Settings

```ini
// ==================== GAMEPLAY ====================

// Starting zombie count each round (minimum 1)
zp_start_zombie_count 1

// Health multipliers
zp_zombie_health_multiplier 1.0
zp_human_health_multiplier 1.0

// Speed multipliers
zp_zombie_speed_multiplier 1.0
zp_human_speed_multiplier 1.0

// Infection settings
zp_infection_chance 100        ; % chance to infect
zp_infection_damage 0          ; Damage dealt when infected
```

### XP & Credits Settings

```ini
// ==================== REWARDS ====================

// Global multipliers
zp_xp_multiplier 1.0
zp_credits_multiplier 1.0

// Per-action rewards
zp_xp_per_kill 10
zp_xp_per_assist 5
zp_xp_per_headshot 15
zp_xp_per_infect 20
zp_xp_per_round_survive 50

zp_credits_per_kill 50
zp_credits_per_assist 25
zp_credits_per_headshot 75
zp_credits_per_infect 100
zp_credits_per_round_survive 250
```

### Level Settings

```ini
// ==================== LEVELING ====================

// Max player level
zp_max_level 100

// XP required per level (base)
zp_xp_per_level 1000

// XP scaling (increases per level)
zp_xp_scaling_factor 1.1

// Reset level on disconnect
zp_reset_level_on_disconnect 0
```

### VIP Settings

```ini
// ==================== VIP ====================

// VIP multipliers
zp_vip_xp_bonus_mult 1.5
zp_vip_credits_bonus_mult 1.5

// VIP max duration (days)
zp_vip_max_duration 30

// Auto-extend VIP (0 = no)
zp_vip_auto_extend 0
```

### Anti-Cheat Settings

```ini
// ==================== ANTI-CHEAT ====================

// Speed limits (units per second)
zp_max_speed_per_second 10000

// XP limits per round
zp_max_xp_per_round 5000

// Credit limits per round
zp_max_credits_per_round 5000

// Warning threshold (kick after this many)
zp_anticheat_warnings_kick 5
```

### Server Message Settings

```ini
// ==================== MESSAGES ====================

// Show tips in center
zp_show_tips 1

// Show class info on spawn
zp_show_class_info 1

// Show achievement notifications
zp_show_achievements 1

// Show event notifications
zp_show_events 1
```

---

## 💎 VIP Config: zp_vip.ini

### VIP Tier 1

```ini
zp_vip1_name "VIP 1"
zp_vip1_price 5000
zp_vip1_duration 30         ; days
zp_vip1_xp_bonus 10         ; %
zp_vip1_credits_bonus 10    ; %
zp_vip1_hp_bonus 100
zp_vip1_speed_bonus 50
zp_vip1_color 0 255 0       ; Green
```

### VIP Tier 2

```ini
zp_vip2_name "VIP 2"
zp_vip2_price 15000
zp_vip2_duration 30
zp_vip2_xp_bonus 20
zp_vip2_credits_bonus 20
zp_vip2_hp_bonus 200
zp_vip2_speed_bonus 100
zp_vip2_color 0 255 255     ; Cyan
```

### VIP Tier 3

```ini
zp_vip3_name "VIP 3"
zp_vip3_price 30000
zp_vip3_duration 30
zp_vip3_xp_bonus 30
zp_vip3_credits_bonus 30
zp_vip3_hp_bonus 300
zp_vip3_speed_bonus 150
zp_vip3_color 255 255 0     ; Yellow
```

### VIP Tier 4

```ini
zp_vip4_name "VIP 4"
zp_vip4_price 50000
zp_vip4_duration 30
zp_vip4_xp_bonus 40
zp_vip4_credits_bonus 40
zp_vip4_hp_bonus 400
zp_vip4_speed_bonus 200
zp_vip4_color 255 100 0     ; Orange
```

### VIP Tier 5

```ini
zp_vip5_name "VIP 5"
zp_vip5_price 100000
zp_vip5_duration 30
zp_vip5_xp_bonus 50
zp_vip5_credits_bonus 50
zp_vip5_hp_bonus 500
zp_vip5_speed_bonus 250
zp_vip5_color 255 0 255     ; Magenta
```

---

## 🎮 Class Config: zp_classes.ini

### Zombie Class Example

```ini
[Zombie_Classic]
Name = "Classic Zombie"
Description = "Standard zombie"
Model = "zombie_classic"
Health = 4000
Speed = 280
Damage = 50
Cost = 0              ; Free
Unlock_Level = 1
Priority = 1
```

### Human Class Example

```ini
[Human_Scout]
Name = "Scout"
Description = "Fast and light"
Model = "human_scout"
Health = 100
Armor = 50
Speed = 400
Cost = 500
Unlock_Level = 1
Weapons = "knife,glock,deagle"
Priority = 1
```

---

## 🎬 Event Config: zp_events.ini

```ini
// ==================== EVENTS ====================

// Double XP Weekend
zp_event_double_xp_enabled 1
zp_event_double_xp_days "Friday,Saturday,Sunday"

// Triple Credits
zp_event_triple_credits_enabled 1
zp_event_triple_credits_frequency "weekly"

// Halloween
zp_event_halloween_enabled 1
zp_event_halloween_start "2026-10-01"
zp_event_halloween_end "2026-10-31"
zp_event_halloween_xp_bonus 150   ; %

// Christmas
zp_event_christmas_enabled 1
zp_event_christmas_start "2026-12-15"
zp_event_christmas_end "2026-12-31"
zp_event_christmas_xp_bonus 200   ; %
```

---

## 🔧 Customization Examples

### Example 1: High Skill Server

Increase difficulty and rewards:

```ini
; zp_config.ini
zp_zombie_health_multiplier 1.5
zp_start_zombie_count 2
zp_max_level 200
zp_xp_scaling_factor 1.15
```

### Example 2: Casual Server

Decrease difficulty, increase rewards:

```ini
; zp_config.ini
zp_zombie_health_multiplier 0.8
zp_start_zombie_count 1
zp_xp_multiplier 2.0
zp_credits_multiplier 2.0
zp_max_xp_per_round 10000
zp_max_credits_per_round 10000
```

### Example 3: VIP Server

Make VIP more attractive:

```ini
; zp_vip.ini
zp_vip1_price 1000          ; Cheaper
zp_vip2_price 3000
zp_vip3_price 7500
zp_vip4_price 15000
zp_vip5_price 30000
```

### Example 4: No Progression

Pure gameplay (no levels/VIP):

```ini
; zp_config.ini
zp_leveling_enabled 0
zp_vip_enabled 0
zp_achievements_enabled 0
```

---

## 📝 Advanced Configuration

### Loading Custom Configs

Create new config file:

```ini
; configs/zp_custom.ini
[Settings]
zp_custom_setting 1
```

Load in plugin:

```amx
// In plugin code
loadconfig("zp_custom.ini");
```

### Performance Tuning

```ini
; Reduce memory usage
zp_max_achievements_tracked 50
zp_max_events_logged 100

; Reduce CPU usage
zp_anticheat_check_interval 5    ; seconds
zp_admin_log_update_interval 10  ; seconds
```

---

## ✅ Configuration Checklist

- [ ] Set correct multipliers for your server difficulty
- [ ] Configure VIP prices to match your economy
- [ ] Enable/disable features as needed
- [ ] Set anti-cheat thresholds appropriately
- [ ] Configure events and seasonal settings
- [ ] Test all changes before going live

---

**Configuration Guide Complete!**

For more help, see README.md or INSTALLATION.md
