/*
 * Zombie Plague Ultimate 6.5 - Anti-Cheat System
 * 
 * File: zp_anticheat.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Basic anti-cheat detection
 * - Speed hack detection
 * - Suspicious behavior logging
 * - Player monitoring
 */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>

#define MAX_DISTANCE 10000.0 // Max distance per second
#define MAX_XP_PER_ROUND 5000 // Max XP per round
#define MAX_CREDITS_PER_ROUND 5000 // Max credits per round

// ==================== GLOBALS ====================

new g_player_last_pos[MAX_PLAYERS + 1][3];
new g_player_last_check[MAX_PLAYERS + 1];
new g_player_xp_this_round[MAX_PLAYERS + 1];
new g_player_credits_this_round[MAX_PLAYERS + 1];
new g_player_warnings[MAX_PLAYERS + 1];

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Anti-Cheat", "6.5", "p1r0maNuL");
    
    // Register forward for player movement
    register_forward(FM_PlayerPreThink, "fwd_player_check");
    register_event("HLTV", "event_round_start", "a");
    
    // Periodic checks
    set_task(1.0, "task_anticheat_check", 0, "", 0, "b");
    
    server_print("[ZP] Anti-Cheat System initialized!");
}

// ==================== EVENTS ====================

public event_round_start() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id)) {
            g_player_xp_this_round[id] = 0;
            g_player_credits_this_round[id] = 0;
            g_player_warnings[id] = 0;
        }
    }
}

// ==================== FORWARD: PLAYER PRETHINK ====================

public fwd_player_check(id) {
    if(!is_user_alive(id))
        return FMRES_IGNORED;
    
    // Get current position
    new pos[3];
    get_user_origin(id, pos);
    
    // Check for speed hack
    new current_time = get_systime();
    
    if(g_player_last_check[id] > 0 && (current_time - g_player_last_check[id]) >= 1) {
        new distance = get_distance(g_player_last_pos[id], pos);
        
        if(distance > MAX_DISTANCE) {
            // Possible speed hack
            warn_player(id, "Speed hack detected");
        }
    }
    
    g_player_last_pos[id][0] = pos[0];
    g_player_last_pos[id][1] = pos[1];
    g_player_last_pos[id][2] = pos[2];
    g_player_last_check[id] = current_time;
    
    return FMRES_IGNORED;
}

// ==================== ANTI-CHEAT CHECKS ====================

public task_anticheat_check() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        
        if(!is_user_connected(id))
            continue;
        
        // Check XP farming
        if(g_player_xp_this_round[id] > MAX_XP_PER_ROUND) {
            warn_player(id, "Excessive XP gain detected");
        }
        
        // Check credit farming
        if(g_player_credits_this_round[id] > MAX_CREDITS_PER_ROUND) {
            warn_player(id, "Excessive credit gain detected");
        }
        
        // Auto-kick after 5 warnings
        if(g_player_warnings[id] >= 5) {
            new name[32];
            get_user_name(id, name, 31);
            server_cmd("kick #%d \"Anti-cheat: Too many violations\"", get_user_userid(id));
            server_print("[ZP] Player %s kicked for anti-cheat violations", name);
        }
    }
}

// ==================== TRACKING ====================

public track_xp_gain(id, amount) {
    g_player_xp_this_round[id] += amount;
}

public track_credits_gain(id, amount) {
    g_player_credits_this_round[id] += amount;
}

public warn_player(id, reason[]) {
    if(!is_user_connected(id))
        return;
    
    g_player_warnings[id]++;
    
    new name[32];
    get_user_name(id, name, 31);
    
    client_print(id, print_chat, "[ZP] WARNING: %s (Warnings: %d/5)", reason, g_player_warnings[id]);
    server_print("[ZP] Anti-Cheat Warning: %s - %s (Warnings: %d)", name, reason, g_player_warnings[id]);
}

// ==================== UTILITY ====================

static get_distance(const from[3], const to[3]) {
    new dx = to[0] - from[0];
    new dy = to[1] - from[1];
    new dz = to[2] - from[2];
    
    return floatround(sqrt(float(dx * dx + dy * dy + dz * dz)));
}

// End of file
