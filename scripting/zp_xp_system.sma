/*
 * Zombie Plague Ultimate 6.5 - XP & Levels System
 * 
 * File: zp_xp_system.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - XP earning from kills, infects, damage, time
 * - Level progression (1-100)
 * - Level-up events and rewards
 * - Persistent player data storage
 */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include "include/zombie_plague.inc"
#include "include/zp_gamemodes.inc"
#include "include/zp_classes.inc"

#define TASK_XP_UPDATE 5000
#define TASK_TIME_BONUS 5001

// ==================== GLOBALS ====================

new g_player_xp[MAX_PLAYERS + 1];
new g_player_level[MAX_PLAYERS + 1];
new g_player_damage[MAX_PLAYERS + 1]; // Damage accumulated for time period
new g_player_playtime[MAX_PLAYERS + 1]; // Playtime in seconds

new cvar_xp_kill;
new cvar_xp_infect;
new cvar_xp_damage;
new cvar_xp_time_interval;
new cvar_levelup_cost;
new cvar_hp_multiplier_per_level;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - XP System", "6.5", "p1r0maNuL");
    
    // Register events
    register_event("DeathMsg", "event_player_death", "a");
    register_event("HLTV", "event_round_start", "a");
    register_logevent("logevent_player_kill", 2, "1=killed");
    
    register_forward(FM_PlayerPreThink, "fwd_player_prethink");
    RegisterHam(Ham_TakeDamage, "player", "ham_takeDamage_pre", 1);
    
    // Register commands
    register_concmd("say /stats", "cmd_show_stats");
    register_concmd("say /level", "cmd_show_level_info");
    register_concmd("say /xp", "cmd_show_xp");
    
    // CVars
    cvar_xp_kill = register_cvar("zp_xp_kill", "100");
    cvar_xp_infect = register_cvar("zp_xp_infect", "50");
    cvar_xp_damage = register_cvar("zp_xp_per_damage", "1");
    cvar_xp_time_interval = register_cvar("zp_xp_time_interval", "180"); // 3 minutes
    cvar_levelup_cost = register_cvar("zp_levelup_cost", "100");
    cvar_hp_multiplier_per_level = register_cvar("zp_hp_mult_per_level", "50"); // +50 HP per level
    
    // Set periodic tasks
    set_task(1.0, "task_playtime_update", 0, "", 0, "b"); // Every 1 second
    set_task(float(get_pcvar_num(cvar_xp_time_interval)), "task_time_bonus", 0, "", 0, "b"); // Time bonus
    
    server_print("[ZP] XP System initialized!");
}

// ==================== EVENTS ====================

public event_round_start() {
    // Reset damage counter for new round
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id))
            g_player_damage[id] = 0;
    }
}

public event_player_death(id) {
    // Handled by logevent_player_kill
}

public logevent_player_kill() {
    new attacker_id = read_logdata(1);
    new victim_id = read_logdata(2);
    new headshot = read_logdata(3);
    
    if(!is_user_connected(attacker_id) || !is_user_connected(victim_id))
        return;
    
    if(attacker_id == victim_id)
        return; // Suicide, no reward
    
    // Award XP to attacker
    new xp_reward = get_pcvar_num(cvar_xp_kill);
    add_player_xp(attacker_id, xp_reward);
    
    client_print(attacker_id, print_chat, "[+%d XP] Kill!", xp_reward);
}

// ==================== DAMAGE HANDLING ====================

public ham_takeDamage_pre(victim, inflictor, attacker, Float:damage, damage_type) {
    if(!is_user_connected(attacker) || attacker == victim)
        return HAM_IGNORED;
    
    // Award XP for damage
    new xp_damage = get_pcvar_num(cvar_xp_damage);
    new damage_int = floatround(damage);
    new xp_reward = damage_int / xp_damage;
    
    if(xp_reward > 0) {
        add_player_xp(attacker, xp_reward);
        g_player_damage[attacker] += damage_int;
    }
    
    return HAM_IGNORED;
}

// ==================== FORWARD: PLAYER PRETHINK ====================

public fwd_player_prethink(id) {
    if(!is_user_alive(id))
        return FMRES_IGNORED;
    
    // Update HUD with XP/Level info
    show_xp_hud(id);
    
    return FMRES_IGNORED;
}

// ==================== PLAYTIME & TIME BONUS ====================

public task_playtime_update() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id))
            g_player_playtime[id]++;
    }
}

public task_time_bonus() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new time_interval = get_pcvar_num(cvar_xp_time_interval);
    new base_xp = 15;
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id) || !is_user_alive(id))
            continue;
        
        // Award time-based XP
        add_player_xp(id, base_xp);
        client_print(id, print_chat, "[+%d XP] Time Bonus!", base_xp);
    }
}

// ==================== XP FUNCTIONS ====================

public add_player_xp(id, amount) {
    if(!is_user_connected(id) || amount <= 0)
        return;
    
    g_player_xp[id] += amount;
    
    // Check for level up
    check_levelup(id);
}

public check_levelup(id) {
    if(!is_user_connected(id))
        return;
    
    new current_level = g_player_level[id];
    
    if(current_level >= MAX_LEVEL)
        return; // Already max level
    
    // Calculate XP needed for next level
    new next_level = current_level + 1;
    new levelup_cost = get_pcvar_num(cvar_levelup_cost);
    new xp_needed = next_level * levelup_cost;
    
    // Check if player has enough XP
    if(g_player_xp[id] >= xp_needed) {
        // Level up!
        g_player_xp[id] -= xp_needed;
        g_player_level[id]++;
        
        new name[32];
        get_user_name(id, name, 31);
        
        // Notify player and server
        client_print(0, print_center, "%s reached Level %d!", name, g_player_level[id]);
        client_print(id, print_chat, "[ZP] **LEVEL UP!** You are now Level %d!", g_player_level[id]);
        
        // Increase HP based on level
        apply_level_bonus(id);
        
        // Recursive check for multiple level-ups
        check_levelup(id);
    }
}

public apply_level_bonus(id) {
    if(!is_user_alive(id))
        return;
    
    new current_hp = get_user_health(id);
    new hp_bonus = get_pcvar_num(cvar_hp_multiplier_per_level);
    new new_hp = current_hp + hp_bonus;
    
    set_user_health(id, new_hp);
    
    client_print(id, print_chat, "[ZP] +%d HP Bonus", hp_bonus);
}

// ==================== HUD DISPLAY ====================

public show_xp_hud(id) {
    new current_level = g_player_level[id];
    new current_xp = g_player_xp[id];
    
    if(current_level >= MAX_LEVEL) {
        // Max level reached
        set_hudmessage(255, 255, 0, -1.0, 0.50, 0, 0.0, 0.1, 0.0, 0.0);
        show_hudmessage(id, "Level: %d (MAX) | Playtime: %dh %dm", 
            current_level, g_player_playtime[id] / 3600, (g_player_playtime[id] % 3600) / 60);
    } else {
        // Calculate XP needed for next level
        new next_level = current_level + 1;
        new levelup_cost = get_pcvar_num(cvar_levelup_cost);
        new xp_needed = next_level * levelup_cost;
        new xp_progress = (current_xp * 100) / xp_needed;
        
        set_hudmessage(0, 255, 100, -1.0, 0.50, 0, 0.0, 0.1, 0.0, 0.0);
        show_hudmessage(id, "Level: %d | XP: %d/%d (%d%%) | Playtime: %dh %dm", 
            current_level, current_xp, xp_needed, xp_progress,
            g_player_playtime[id] / 3600, (g_player_playtime[id] % 3600) / 60);
    }
}

// ==================== COMMANDS ====================

public cmd_show_stats(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new name[32];
    get_user_name(id, name, 31);
    
    new current_level = g_player_level[id];
    new current_xp = g_player_xp[id];
    new playtime = g_player_playtime[id];
    
    client_print(id, print_chat, "======== YOUR STATS ========");
    client_print(id, print_chat, "Player: %s", name);
    client_print(id, print_chat, "Level: %d / %d", current_level, MAX_LEVEL);
    client_print(id, print_chat, "XP: %d", current_xp);
    client_print(id, print_chat, "Playtime: %dh %dm %ds", 
        playtime / 3600, (playtime % 3600) / 60, playtime % 60);
    client_print(id, print_chat, "============================");
    
    return PLUGIN_HANDLED;
}

public cmd_show_level_info(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new current_level = g_player_level[id];
    
    if(current_level >= MAX_LEVEL) {
        client_print(id, print_chat, "[ZP] You are at MAX LEVEL!");
    } else {
        new next_level = current_level + 1;
        new levelup_cost = get_pcvar_num(cvar_levelup_cost);
        new xp_needed = next_level * levelup_cost;
        new xp_progress = g_player_xp[id];
        
        client_print(id, print_chat, "[ZP] Current Level: %d", current_level);
        client_print(id, print_chat, "[ZP] XP to Next Level: %d/%d", xp_progress, xp_needed);
        client_print(id, print_chat, "[ZP] Next Level: %d", next_level);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_show_xp(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new current_xp = g_player_xp[id];
    new current_level = g_player_level[id];
    
    if(current_level >= MAX_LEVEL) {
        client_print(id, print_chat, "[ZP] You are at MAX LEVEL - No more XP needed!");
    } else {
        new next_level = current_level + 1;
        new levelup_cost = get_pcvar_num(cvar_levelup_cost);
        new xp_needed = next_level * levelup_cost;
        new remaining_xp = xp_needed - current_xp;
        
        client_print(id, print_chat, "[ZP] You have: %d XP", current_xp);
        client_print(id, print_chat, "[ZP] You need: %d more XP to reach Level %d", remaining_xp, next_level);
    }
    
    return PLUGIN_HANDLED;
}

// ==================== GETTER/SETTER ====================

public get_player_level(id) {
    if(!is_user_connected(id))
        return 0;
    return g_player_level[id];
}

public set_player_level(id, new_level) {
    if(!is_user_connected(id) || new_level < MIN_LEVEL || new_level > MAX_LEVEL)
        return;
    g_player_level[id] = new_level;
}

public get_player_xp(id) {
    if(!is_user_connected(id))
        return 0;
    return g_player_xp[id];
}

public get_player_playtime(id) {
    if(!is_user_connected(id))
        return 0;
    return g_player_playtime[id];
}

// End of file
