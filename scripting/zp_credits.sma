/*
 * Zombie Plague Ultimate 6.5 - Credits System
 * 
 * File: zp_credits.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Credits earning from kills, infects, damage, time
 * - Credits balance management
 * - Time presents (periodic credit rewards)
 * - Credits persistence in database
 */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include "include/zombie_plague.inc"

#define TASK_TIME_CREDITS 6000

// ==================== GLOBALS ====================

new g_player_credits[MAX_PLAYERS + 1];
new g_player_last_credits_time[MAX_PLAYERS + 1];

new cvar_credits_kill;
new cvar_credits_infect;
new cvar_credits_damage;
new cvar_time_presents_interval;
new cvar_time_presents_amount;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Credits System", "6.5", "p1r0maNuL");
    
    // Register events
    register_logevent("logevent_player_kill", 2, "1=killed");
    register_event("HLTV", "event_round_start", "a");
    
    register_forward(FM_PlayerPreThink, "fwd_player_prethink");
    RegisterHam(Ham_TakeDamage, "player", "ham_takeDamage_pre", 1);
    
    // Register commands
    register_concmd("say /credits", "cmd_show_credits");
    register_concmd("say /money", "cmd_show_credits");
    register_concmd("say /bal", "cmd_show_credits");
    
    // CVars
    cvar_credits_kill = register_cvar("zp_credits_kill", "50");
    cvar_credits_infect = register_cvar("zp_credits_infect", "25");
    cvar_credits_damage = register_cvar("zp_credits_per_damage", "10");
    cvar_time_presents_interval = register_cvar("zp_time_presents_interval", "180"); // 3 minutes
    cvar_time_presents_amount = register_cvar("zp_time_presents_amount", "15");
    
    // Time-based credits task
    set_task(float(get_pcvar_num(cvar_time_presents_interval)), "task_time_credits", 0, "", 0, "b");
    
    server_print("[ZP] Credits System initialized!");
}

// ==================== EVENTS ====================

public event_round_start() {
    // Reset time tracker
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id))
            g_player_last_credits_time[id] = 0;
    }
}

public logevent_player_kill() {
    new attacker_id = read_logdata(1);
    new victim_id = read_logdata(2);
    
    if(!is_user_connected(attacker_id) || !is_user_connected(victim_id))
        return;
    
    if(attacker_id == victim_id)
        return; // Suicide, no reward
    
    // Award credits to attacker
    new credits_reward = get_pcvar_num(cvar_credits_kill);
    add_player_credits(attacker_id, credits_reward);
    
    client_print(attacker_id, print_chat, "[+$%d] Kill!", credits_reward);
}

// ==================== DAMAGE HANDLING ====================

public ham_takeDamage_pre(victim, inflictor, attacker, Float:damage, damage_type) {
    if(!is_user_connected(attacker) || attacker == victim)
        return HAM_IGNORED;
    
    // Award credits for damage
    new credits_damage = get_pcvar_num(cvar_credits_damage);
    new damage_int = floatround(damage);
    new credits_reward = damage_int / credits_damage;
    
    if(credits_reward > 0) {
        add_player_credits(attacker, credits_reward);
    }
    
    return HAM_IGNORED;
}

// ==================== FORWARD: PLAYER PRETHINK ====================

public fwd_player_prethink(id) {
    if(!is_user_alive(id))
        return FMRES_IGNORED;
    
    // Update HUD with credits
    show_credits_hud(id);
    
    return FMRES_IGNORED;
}

// ==================== TIME BONUS CREDITS ====================

public task_time_credits() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new time_presents_amount = get_pcvar_num(cvar_time_presents_amount);
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id) || !is_user_alive(id))
            continue;
        
        // Award time-based credits
        add_player_credits(id, time_presents_amount);
        client_print(id, print_chat, "[+$%d] Time Present!", time_presents_amount);
    }
}

// ==================== CREDITS FUNCTIONS ====================

public add_player_credits(id, amount) {
    if(!is_user_connected(id) || amount <= 0)
        return;
    
    g_player_credits[id] += amount;
    
    // Cap credits at max
    if(g_player_credits[id] > MAX_CREDITS)
        g_player_credits[id] = MAX_CREDITS;
}

public remove_player_credits(id, amount) {
    if(!is_user_connected(id) || amount <= 0)
        return 0;
    
    if(g_player_credits[id] >= amount) {
        g_player_credits[id] -= amount;
        return 1; // Success
    }
    
    return 0; // Failed - not enough credits
}

public get_player_credits(id) {
    if(!is_user_connected(id))
        return 0;
    return g_player_credits[id];
}

public set_player_credits(id, amount) {
    if(!is_user_connected(id) || amount < 0)
        return;
    
    if(amount > MAX_CREDITS)
        g_player_credits[id] = MAX_CREDITS;
    else
        g_player_credits[id] = amount;
}

// ==================== HUD DISPLAY ====================

public show_credits_hud(id) {
    new credits = g_player_credits[id];
    
    set_hudmessage(0, 255, 0, -1.0, 0.75, 0, 0.0, 0.1, 0.0, 0.0);
    show_hudmessage(id, "Credits: $%d", credits);
}

// ==================== COMMANDS ====================

public cmd_show_credits(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new credits = g_player_credits[id];
    
    client_print(id, print_chat, "[ZP] You have: $%d", credits);
    client_print(id, print_chat, "[ZP] Use /shop to buy items!");
    
    return PLUGIN_HANDLED;
}

// End of file
