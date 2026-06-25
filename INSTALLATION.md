# Installation Guide - Zombie Plague Ultimate 6.5

## 📋 Prerequisites

Before installing Zombie Plague Ultimate 6.5, ensure you have:

- ✅ Half-Life: Counter-Strike dedicated server
- ✅ AMXModX 1.10 or higher
- ✅ MetaMod installed
- ✅ Linux or Windows server OS
- ✅ Admin/root access to server

---

## 🚀 Quick Installation (5 Minutes)

### Step 1: Download

```bash
cd /path/to/cstrike/
wget https://github.com/p1r0maNuL/ZombiePlague-Ultimate-6.5/releases/download/v6.5/zp-6.5.zip
unzip zp-6.5.zip
```

### Step 2: Extract to Correct Locations

```bash
# Plugins (compiled .amxx files)
cp plugins/* addons/amxmodx/plugins/

# Configs
cp configs/* addons/amxmodx/configs/

# Sounds (optional)
cp -r sound/* ./
```

### Step 3: Enable in AMXModX

Edit `addons/amxmodx/configs/plugins.ini`:

```ini
; Zombie Plague Ultimate 6.5
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

### Step 4: Set File Permissions

```bash
chmod 755 addons/amxmodx/plugins/*.amxx
chmod 644 addons/amxmodx/configs/*.ini
```

### Step 5: Restart Server

```bash
# Option 1: In-game console
rcon restart

# Option 2: Shell
./restart.sh

# Option 3: Manual
./hlds_run -game cstrike +map de_dust
```

### Step 6: Verify Installation

In-game console:
```
/info
```

You should see Zombie Plague version info.

---

## 🔧 Detailed Installation (Linux)

### 1. Directory Structure

Your server should have this structure:

```
/home/gameserver/cstrike/
├── addons/
│   └── amxmodx/
│       ├── plugins/
│       │   ├── zp_core.amxx
│       │   ├── zp_classes.amxx
│       │   ├── ... (other plugins)
│       │   └── compiled.ini
│       ├── configs/
│       │   ├── zp_config.ini
│       │   ├── zp_vip.ini
│       │   ├── zp_classes.ini
│       │   ├── plugins.ini
│       │   └── ... (other configs)
│       ├── data/
│       ├── logs/
│       └── scripting/
├── cstrike/
│   ├── maps/
│   ├── models/
│   ├── sound/
│   └── sprites/
├── hlds_run (executable)
└── restart.sh
```

### 2. Install AMXModX (if not already installed)

```bash
# Download latest AMXModX
wget https://www.amxmodx.org/release/amxmodx-latest-linux.tar.gz

# Extract to server
tar -xzf amxmodx-latest-linux.tar.gz -C /home/gameserver/cstrike/

# Permissions
chmod -R 755 /home/gameserver/cstrike/addons/amxmodx/
```

### 3. Copy Plugin Files

```bash
# Create backup
cp -r addons/amxmodx/plugins addons/amxmodx/plugins.backup

# Copy ZP plugins
cp zp-6.5/plugins/*.amxx addons/amxmodx/plugins/

# Verify
ls -la addons/amxmodx/plugins/ | grep zp_
```

### 4. Copy Configuration Files

```bash
# Create backup
cp -r addons/amxmodx/configs addons/amxmodx/configs.backup

# Copy ZP configs
cp zp-6.5/configs/*.ini addons/amxmodx/configs/

# Verify
ls -la addons/amxmodx/configs/ | grep zp_
```

### 5. Update plugins.ini

```bash
# Edit plugins.ini
nano addons/amxmodx/configs/plugins.ini

# Add these lines at the end:
; Zombie Plague Ultimate 6.5
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

# Save: Ctrl+O, Enter, Ctrl+X
```

### 6. Restart Server

```bash
# Stop server
kill $(pgrep -f hlds_run)

# Wait 5 seconds
sleep 5

# Start server
cd /home/gameserver/cstrike/
./hlds_run -game cstrike +map de_dust +port 27015 +maxplayers 32 &

# Check if running
ps aux | grep hlds_run
```

### 7. Test Installation

```bash
# Connect to server
# In console: /info

# Or check logs
cat addons/amxmodx/logs/error.log
cat addons/amxmodx/logs/amxmodx.log
```

---

## 🔧 Detailed Installation (Windows)

### 1. Prepare Server

```batch
# Navigate to server directory
cd C:\GameServers\cstrike

# Create backup
xcopy addons\amxmodx\plugins addons\amxmodx\plugins.backup /E /I
```

### 2. Extract ZP Files

```batch
# Extract ZIP
# Right-click zp-6.5.zip → Extract All

# Copy plugins
copy zp-6.5\plugins\*.amxx addons\amxmodx\plugins\

# Copy configs
copy zp-6.5\configs\*.ini addons\amxmodx\configs\
```

### 3. Update plugins.ini

```batch
# Open with notepad
notpad addons\amxmodx\configs\plugins.ini

# Add at end:
; Zombie Plague Ultimate 6.5
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

# Save and close
```

### 4. Restart Server

```batch
# Stop server (if running)
# In console: quit

# Start server
hlds.exe -game cstrike +map de_dust +port 27015 +maxplayers 32
```

### 5. Verify

```batch
# Check error log
type addons\amxmodx\logs\error.log
```

---

## ✅ Post-Installation Checklist

- [ ] All 11 plugins loaded in server (check: `amx_plugins`)
- [ ] No errors in `addons/amxmodx/logs/error.log`
- [ ] `/info` command works and shows ZP info
- [ ] `/classes` shows zombie and human classes
- [ ] `/vip` opens VIP shop
- [ ] `/achievements` shows achievement list
- [ ] `/events` shows active events

---

## 🚨 Troubleshooting Installation

### Problem: Plugins not loading

**Cause:** Missing files or typos in plugins.ini

**Fix:**
```bash
# Check logs
cat addons/amxmodx/logs/error.log

# Verify files exist
ls addons/amxmodx/plugins/zp_*.amxx

# Check plugins.ini syntax
grep -n "zp_" addons/amxmodx/configs/plugins.ini
```

### Problem: Commands don't work

**Cause:** Plugin not fully loaded

**Fix:**
```bash
# Reload plugin
rcon amx_loadplugin addons/amxmodx/plugins/zp_core.amxx

# Check all plugins
rcon amx_plugins
```

### Problem: Classes not showing

**Cause:** Config file not found

**Fix:**
```bash
# Verify config exists
ls -la addons/amxmodx/configs/zp_*.ini

# Check permissions
chmod 644 addons/amxmodx/configs/zp_*.ini
```

### Problem: Server crashes on startup

**Cause:** Incompatible AMXModX version

**Fix:**
```bash
# Check AMXModX version
rcon amx_version

# Required: 1.10 or higher
# Download latest from amxmodx.org
```

---

## 🔄 Updating to 6.5

If upgrading from 6.0 or earlier:

### 1. Backup Current Installation

```bash
cp -r addons/amxmodx addons/amxmodx.backup.6.0
cp -r cstrike cstrike.backup.6.0
```

### 2. Stop Server

```bash
rcon quit
```

### 3. Extract New Version

```bash
unzip zp-6.5.zip
cp zp-6.5/plugins/* addons/amxmodx/plugins/
cp zp-6.5/configs/* addons/amxmodx/configs/
```

### 4. Update plugins.ini

Add new plugins (from Phase 7-10):

```ini
zp_admin_tools.amxx
zp_anticheat.amxx
zp_game_modes.amxx
zp_mode_features.amxx
zp_events_seasonal.amxx
zp_special_events.amxx
```

### 5. Restart Server

```bash
rcon restart
```

### 6. Verify

All old players keep their data (auto-migrated).

---

## 📞 Getting Help

If installation fails:

1. **Check Error Logs**: `addons/amxmodx/logs/error.log`
2. **Read Documentation**: See README.md
3. **Report Bug**: https://github.com/p1r0maNuL/ZombiePlague-Ultimate-6.5/issues
4. **Ask for Help**: Discord support server

---

**Installation Complete! Enjoy Zombie Plague Ultimate 6.5! 🧟**
