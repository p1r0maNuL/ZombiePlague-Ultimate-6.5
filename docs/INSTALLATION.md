# Zombie Plague Ultimate 6.5 - Installation Guide

## Prerequisites

- Counter-Strike 1.6 Server
- AMXModX 1.9.0 or higher
- Metamod-r
- MySQL Server (optional, for persistent data)
- Reunion (optional, for anti-cheat)

## Step 1: Prepare Your Server

1. Install AMXModX 1.9.0
2. Install Metamod-r
3. Configure `liblist.gam` to load Metamod

## Step 2: Setup Database (MySQL)

### Create Database

```bash
mysql -u root -p < sql/zp_database.sql
```

### Update Configuration

Edit `configs/zp_config.ini`:

```ini
zp_database_type 1
zp_db_host "localhost"
zp_db_user "your_username"
zp_db_pass "your_password"
zp_db_name "zombie_plague"
zp_db_port 3306
```

## Step 3: Install Plugin Files

1. Copy `scripting/` files to `addons/amxmodx/scripting/`
2. Copy `configs/` files to `addons/amxmodx/configs/`
3. Compile plugins:

```bash
amxmodx-compiler scripting/zp_main.sma
```

4. Copy compiled `.amxx` files to `addons/amxmodx/plugins/`

## Step 4: Configure plugins.ini

Add to `addons/amxmodx/configs/plugins.ini`:

```
zp_main.amxx        ; Zombie Plague Ultimate 6.5
```

## Step 5: Load Configuration

Add to `server.cfg`:

```
exec addons/amxmodx/configs/zp_config.ini
```

## Step 6: Start Server

```bash
./hlds_run -game cstrike +ip 0.0.0.0 +port 27015
```

## Troubleshooting

### Plugin not loading

- Check `addons/amxmodx/logs/` for error messages
- Verify `.amxx` files are compiled correctly
- Check `plugins.ini` for syntax errors

### Database connection failed

- Verify MySQL server is running
- Check database credentials in `zp_config.ini`
- Ensure database exists and tables are created

### Compilation errors

- Update AMXModX compiler
- Check include file paths
- Verify all dependencies are included

## Next Steps

- See [CONFIGURATION.md](CONFIGURATION.md) for advanced setup
- See [COMMANDS.md](COMMANDS.md) for in-game commands
- See [API.md](API.md) for plugin development
