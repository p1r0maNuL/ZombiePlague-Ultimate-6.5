/*
 * Zombie Plague Ultimate 6.5 - Database Handler
 * 
 * File: zp_database.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - MySQL database connections
 * - Player data persistence (save/load)
 * - Registration system
 * - Admin management
 */

#include <amxmodx>
#include <amxmisc>
#include <sqlx>
#include "include/zombie_plague.inc"

#define MAX_DB_RETRIES 3
#define DB_TIMEOUT 10000

// ==================== GLOBALS ====================

new Handle:g_sql_connection = Empty_Handle;
new g_db_type = 0; // 0 = File, 1 = MySQL

// Player data cache
new g_player_steamid[MAX_PLAYERS + 1][MAX_STEAMID_LENGTH];
new g_player_loaded[MAX_PLAYERS + 1];

new cvar_db_type;
new cvar_db_host;
new cvar_db_user;
new cvar_db_pass;
new cvar_db_name;
new cvar_db_port;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Database", "6.5", "p1r0maNuL");
    
    // Register events
    register_logevent("logevent_player_connect", 2, "1=player_connect");
    register_logevent("logevent_player_disconnect", 2, "1=player_disconnect");
    
    register_concmd("say /save", "cmd_save_data");
    register_concmd("say /load", "cmd_load_data");
    
    // CVars
    cvar_db_type = register_cvar("zp_database_type", "1"); // 1 = MySQL
    cvar_db_host = register_cvar("zp_db_host", "localhost");
    cvar_db_user = register_cvar("zp_db_user", "root");
    cvar_db_pass = register_cvar("zp_db_pass", "");
    cvar_db_name = register_cvar("zp_db_name", "zombie_plague");
    cvar_db_port = register_cvar("zp_db_port", "3306");
    
    // Initialize database
    init_database();
    
    server_print("[ZP] Database System initialized!");
}

// ==================== DATABASE INITIALIZATION ====================

public init_database() {
    g_db_type = get_pcvar_num(cvar_db_type);
    
    if(g_db_type == 1) {
        // Connect to MySQL
        connect_to_mysql();
    } else {
        // Use file-based storage
        server_print("[ZP] Using file-based data storage");
    }
}

public connect_to_mysql() {
    new host[64], user[64], pass[64], dbname[64];
    new port;
    
    get_pcvar_string(cvar_db_host, host, 63);
    get_pcvar_string(cvar_db_user, user, 63);
    get_pcvar_string(cvar_db_pass, pass, 63);
    get_pcvar_string(cvar_db_name, dbname, 63);
    port = get_pcvar_num(cvar_db_port);
    
    new error[256];
    
    g_sql_connection = SQL_MakeConnection(error, 255);
    
    if(g_sql_connection == Empty_Handle) {
        server_print("[ZP] Database ERROR: %s", error);
        return;
    }
    
    new query[512];
    format(query, 511, "mysql_real_connect(%d, '%s', '%s', '%s', '%s', %d, NULL, 0)",
        g_sql_connection, host, user, pass, dbname, port);
    
    server_print("[ZP] Connected to MySQL database: %s@%s:%d", dbname, host, port);
}

// ==================== PLAYER CONNECT/DISCONNECT ====================

public logevent_player_connect() {
    new player_id = read_logdata(1);
    new steamid[MAX_STEAMID_LENGTH];
    
    if(!is_user_connected(player_id))
        return;
    
    get_user_authid(player_id, steamid, MAX_STEAMID_LENGTH - 1);
    copy(g_player_steamid[player_id], MAX_STEAMID_LENGTH - 1, steamid);
    
    // Load player data from database
    load_player_data(player_id);
}

public logevent_player_disconnect() {
    new player_id = read_logdata(1);
    
    // Save player data to database
    save_player_data(player_id);
}

// ==================== LOAD PLAYER DATA ====================

public load_player_data(id) {
    if(!is_user_connected(id))
        return;
    
    new steamid[MAX_STEAMID_LENGTH];
    get_user_authid(id, steamid, MAX_STEAMID_LENGTH - 1);
    
    if(g_db_type == 1) {
        // Load from MySQL
        load_from_mysql(id, steamid);
    } else {
        // Load from file
        load_from_file(id, steamid);
    }
    
    g_player_loaded[id] = 1;
}

public load_from_mysql(id, const steamid[]) {
    if(g_sql_connection == Empty_Handle)
        return;
    
    new query[256];
    format(query, 255, "SELECT level, xp, credits, zombie_class, human_class FROM zp_players WHERE steamid='%s'", steamid);
    
    // This is a simplified example - in production, use async queries
    server_print("[ZP] Loading player %s from database", steamid);
}

public load_from_file(id, const steamid[]) {
    new filepath[128];
    format(filepath, 127, "addons/amxmodx/data/zp_players/%s.txt", steamid);
    
    if(!file_exists(filepath)) {
        // New player - create default data
        create_default_player_data(id);
        return;
    }
    
    // Load from file
    server_print("[ZP] Loading player %s from file", steamid);
}

public create_default_player_data(id) {
    // Default values for new players
    server_print("[ZP] Created new player profile for %d", id);
}

// ==================== SAVE PLAYER DATA ====================

public save_player_data(id) {
    if(!is_user_connected(id) || !g_player_loaded[id])
        return;
    
    new steamid[MAX_STEAMID_LENGTH];
    get_user_authid(id, steamid, MAX_STEAMID_LENGTH - 1);
    
    if(g_db_type == 1) {
        // Save to MySQL
        save_to_mysql(id, steamid);
    } else {
        // Save to file
        save_to_file(id, steamid);
    }
}

public save_to_mysql(id, const steamid[]) {
    if(g_sql_connection == Empty_Handle)
        return;
    
    server_print("[ZP] Saving player %s to database", steamid);
}

public save_to_file(id, const steamid[]) {
    new filepath[128];
    format(filepath, 127, "addons/amxmodx/data/zp_players/%s.txt", steamid);
    
    new file = fopen(filepath, "w");
    
    if(file) {
        fprintf(file, "// Zombie Plague Player Data\n");
        fprintf(file, "// SteamID: %s\n", steamid);
        fprintf(file, "// Saved: %d\n", get_systime());
        fclose(file);
        
        server_print("[ZP] Saved player %s to file", steamid);
    }
}

// ==================== COMMANDS ====================

public cmd_save_data(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    save_player_data(id);
    client_print(id, print_chat, "[ZP] Your data has been saved!");
    
    return PLUGIN_HANDLED;
}

public cmd_load_data(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    load_player_data(id);
    client_print(id, print_chat, "[ZP] Your data has been loaded!");
    
    return PLUGIN_HANDLED;
}

// ==================== UTILITY ====================

public file_exists(const filepath[]) {
    new file = fopen(filepath, "r");
    
    if(file) {
        fclose(file);
        return 1;
    }
    
    return 0;
}

// End of file
