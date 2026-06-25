/*
 * Zombie Plague Ultimate 6.5 - Core Engine
 * 
 * File: zp_core_engine.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file contains the main game engine logic:
 * - Round management
 * - Zombie/Human role assignment
 * - Game mode control
 * - Basic mechanics (HP, damage, death handling)
 */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include "include/zombie_plague.inc"
#include "include/zp_gamemodes.inc"
#include "include/zp_classes.inc"

#define TASK_ROUNDEND 1000
#define TASK_RESPAWN 2000

// ==================== GLOBALS ====================

new g_current_gamemode = GAMEMODE_INFECTION;
new g_round_active = 0;
new g_round_num = 0;
new g_last_gamemode = -1;
new g_zombie_count = 0;
new g_human_count = 0;

new g_player_role[MAX_PLAYERS + 1];
new g_player_hp[MAX_PLAYERS + 1];
new g_player_armor[MAX_PLAYERS + 1];
new g_player_is_infected[MAX_PLAYERS + 1];

new cvar_zombie_hp;
new cvar_human_hp;
new cvar_gamemode_chance;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Core Engine", "6.5", "p1r0maNuL");
    
    // Register events
    register_event("HLTV", "event_round_start", "a");
    register_event("SendAudio", "event_round_end", "be", "2&%!");
    register_logevent("logevent_round_start", 2, "1=Round_Start");
    register_logevent("logevent_round_end", 2, "1=Round_End");
    
    register_forward(FM_PlayerPreThink, "fwd_player_prethink");
    RegisterHam(Ham_TakeDamage, "player", "ham_takeDamage");
    RegisterHam(Ham_Killed, "player", "ham_player_killed");
    
    // Register commands
    register_concmd("say /role", "cmd_show_role");
    register_concmd("say /me", "cmd_show_status");
    
    // CVars
    cvar_zombie_hp = register_cvar("zp_zombie_hp_mult", "1.0");
    cvar_human_hp = register_cvar("zp_human_hp_mult", "1.0");
    cvar_gamemode_chance = register_cvar("zp_gamemode_chance", "30");
    
    server_print("[ZP] Core Engine initialized!");
}

public plugin_precache() {
    // Precache resources
}

// ==================== ROUND EVENTS ====================

public event_round_start() {
    if(g_round_active)
        return;
    
    g_round_active = 1;
    g_round_num++;
    g_zombie_count = 0;
    g_human_count = 0;
    
    // Select game mode
    select_gamemode();
    
    // Initialize players
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id))
            continue;
        
        // Default: Human role
        g_player_role[id] = ROLE_HUMAN;
        g_player_is_infected[id] = 0;
        g_player_hp[id] = 100;
        g_player_armor[id] = 0;
    }
    
    // Apply game mode logic
    apply_gamemode();
    
    // Spawn players
    set_task(0.5, "task_spawn_players");
    
    // Notify server
    new mode_name[32];
    ZP_GameMode_GetInfo(g_current_gamemode, mode_name);
    server_print("[ZP] Round %d started - Mode: %s", g_round_num, mode_name);
    
    // Notify all players
    client_print(0, print_center, "Game Mode: %s", mode_name);
}

public event_round_end() {
    if(!g_round_active)
        return;
    
    g_round_active = 0;
    
    new winner = 0;
    if(g_zombie_count > 0 && g_human_count == 0)
        winner = 1; // Zombies won
    else if(g_human_count > 0 && g_zombie_count == 0)
        winner = 2; // Humans won
    else
        winner = 0; // Tie or draw
    
    server_print("[ZP] Round %d ended - Winner: %d", g_round_num, winner);
    
    // Reset players
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id))
            continue;
        
        g_player_role[id] = ROLE_HUMAN;
        g_player_is_infected[id] = 0;
    }
}

public logevent_round_start() {
    event_round_start();
}

public logevent_round_end() {
    event_round_end();
}

// ==================== GAME MODE SELECTION ====================

public select_gamemode() {
    new chance = get_pcvar_num(cvar_gamemode_chance);
    new random_mode = random(chance);
    
    // Select new mode (don't repeat)
    new new_mode = g_current_gamemode;
    
    if(random_mode == 0) {
        // Random mode selection
        new_mode = random(MAX_GAME_MODES);
        
        // Avoid repeating same mode
        while(new_mode == g_last_gamemode && MAX_GAME_MODES > 1) {
            new_mode = random(MAX_GAME_MODES);
        }
    }
    
    g_last_gamemode = g_current_gamemode;
    g_current_gamemode = new_mode;
}

public apply_gamemode() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    switch(g_current_gamemode) {
        case GAMEMODE_INFECTION: {
            // One random zombie
            if(count > 0) {
                new random_zombie = players[random(count)];
                g_player_role[random_zombie] = ROLE_ZOMBIE;
                g_player_is_infected[random_zombie] = 1;
                g_zombie_count = 1;
                g_human_count = count - 1;
            }
        }
        case GAMEMODE_NEMESIS: {
            // One nemesis zombie
            if(count > 0) {
                new random_zombie = players[random(count)];
                g_player_role[random_zombie] = ROLE_NEMESIS;
                g_player_is_infected[random_zombie] = 1;
                g_zombie_count = 1;
                g_human_count = count - 1;
            }
        }
        case GAMEMODE_SURVIVOR: {
            // One survivor human
            if(count > 0) {
                new random_survivor = players[random(count)];
                g_player_role[random_survivor] = ROLE_SURVIVOR;
                g_zombie_count = count - 1;
                g_human_count = 1;
            }
        }
        case GAMEMODE_SWARM: {
            // All zombies
            if(count >= 10) {
                for(new i = 0; i < count; i++) {
                    new id = players[i];
                    g_player_role[id] = ROLE_SWARM;
                    g_player_is_infected[id] = 1;
                }
                g_zombie_count = count;
                g_human_count = 0;
            } else {
                // Fall back to infection if not enough players
                g_player_role[players[0]] = ROLE_ZOMBIE;
                g_player_is_infected[players[0]] = 1;
                g_zombie_count = 1;
                g_human_count = count - 1;
            }
        }
        case GAMEMODE_MULTIPLE_INFECTION: {
            // Multiple zombies based on player count
            if(count >= 6) {
                new zombie_count = max(1, count / 4);
                for(new i = 0; i < zombie_count && i < count; i++) {
                    new random_zombie = players[random(count)];
                    g_player_role[random_zombie] = ROLE_ZOMBIE;
                    g_player_is_infected[random_zombie] = 1;
                }
                g_zombie_count = zombie_count;
                g_human_count = count - zombie_count;
            } else {
                // Fall back to infection
                g_player_role[players[0]] = ROLE_ZOMBIE;
                g_player_is_infected[players[0]] = 1;
                g_zombie_count = 1;
                g_human_count = count - 1;
            }
        }
    }
}

// ==================== PLAYER SPAWN ====================

public task_spawn_players() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id) || !is_user_alive(id))
            continue;
        
        new role = g_player_role[id];
        
        switch(role) {
            case ROLE_HUMAN: {
                set_user_team(id, 2); // CT
                set_user_health(id, 100);
                set_user_armor(id, 25);
                give_item(id, "weapon_m4a1");
                give_item(id, "weapon_glock18");
            }
            case ROLE_ZOMBIE, ROLE_SWARM: {
                set_user_team(id, 1); // TERRORIST
                set_user_health(id, 4000);
                strip_user_weapons(id);
                give_item(id, "weapon_knife");
            }
            case ROLE_NEMESIS: {
                set_user_team(id, 1); // TERRORIST
                set_user_health(id, 150000);
                strip_user_weapons(id);
                give_item(id, "weapon_knife");
            }
            case ROLE_SURVIVOR: {
                set_user_team(id, 2); // CT
                set_user_health(id, 6000);
                set_user_armor(id, 100);
                strip_user_weapons(id);
                give_item(id, "weapon_m4a1");
                give_item(id, "weapon_glock18");
            }
        }
    }
}

// ==================== DAMAGE HANDLING ====================

public ham_takeDamage(victim, inflictor, attacker, Float:damage, damage_type) {
    if(!is_user_alive(victim))
        return HAM_IGNORED;
    
    new victim_role = g_player_role[victim];
    new attacker_role = g_player_role[attacker];
    
    // Zombies can't damage humans with guns (only melee)
    if(victim_role == ROLE_HUMAN && attacker_role == ROLE_ZOMBIE) {
        // Only allow knife damage
        if(!(damage_type & DMG_ALWAYSGIB))
            return HAM_SUPERCEDE;
    }
    
    return HAM_IGNORED;
}

public ham_player_killed(victim, attacker, shouldgib) {
    if(!is_user_connected(victim))
        return HAM_IGNORED;
    
    new victim_role = g_player_role[victim];
    new attacker_role = g_player_role[attacker];
    
    // If zombie kills human, human becomes zombie
    if(victim_role == ROLE_HUMAN && (attacker_role == ROLE_ZOMBIE || attacker_role == ROLE_NEMESIS)) {
        // Infect human
        g_player_role[victim] = ROLE_ZOMBIE;
        g_player_is_infected[victim] = 1;
        g_zombie_count++;
        g_human_count--;
        
        client_print(victim, print_center, "You have been infected!");
        client_print(attacker, print_chat, "[+] You infected a human!");
    }
    
    return HAM_IGNORED;
}

// ==================== FORWARD: PLAYER PRETHINK ====================

public fwd_player_prethink(id) {
    if(!is_user_alive(id))
        return FMRES_IGNORED;
    
    // Update HUD
    show_player_hud(id);
    
    return FMRES_IGNORED;
}

// ==================== HUD UPDATES ====================

public show_player_hud(id) {
    new role_name[32];
    
    switch(g_player_role[id]) {
        case ROLE_HUMAN: role_name = "HUMAN";
        case ROLE_ZOMBIE: role_name = "ZOMBIE";
        case ROLE_NEMESIS: role_name = "NEMESIS";
        case ROLE_SURVIVOR: role_name = "SURVIVOR";
        case ROLE_SNIPER: role_name = "SNIPER";
        case ROLE_ASSASSIN: role_name = "ASSASSIN";
        case ROLE_SWARM: role_name = "SWARM";
        case ROLE_DRAGON: role_name = "DRAGON";
        default: role_name = "UNKNOWN";
    }
    
    new hp = get_user_health(id);
    new armor = get_user_armor(id);
    
    set_hudmessage(0, 255, 0, -1.0, 0.65, 0, 0.0, 0.1, 0.0, 0.0);
    show_hudmessage(id, "Role: %s | HP: %d | Armor: %d | Zombies: %d | Humans: %d", 
        role_name, hp, armor, g_zombie_count, g_human_count);
}

// ==================== COMMANDS ====================

public cmd_show_role(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new role_name[32];
    
    switch(g_player_role[id]) {
        case ROLE_HUMAN: role_name = "HUMAN";
        case ROLE_ZOMBIE: role_name = "ZOMBIE";
        case ROLE_NEMESIS: role_name = "NEMESIS";
        case ROLE_SURVIVOR: role_name = "SURVIVOR";
        case ROLE_SNIPER: role_name = "SNIPER";
        case ROLE_ASSASSIN: role_name = "ASSASSIN";
        case ROLE_SWARM: role_name = "SWARM";
        case ROLE_DRAGON: role_name = "DRAGON";
        default: role_name = "UNKNOWN";
    }
    
    client_print(id, print_chat, "[ZP] Your role: %s", role_name);
    
    return PLUGIN_HANDLED;
}

public cmd_show_status(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new role_name[32];
    new mode_name[32];
    
    switch(g_player_role[id]) {
        case ROLE_HUMAN: role_name = "HUMAN";
        case ROLE_ZOMBIE: role_name = "ZOMBIE";
        case ROLE_NEMESIS: role_name = "NEMESIS";
        case ROLE_SURVIVOR: role_name = "SURVIVOR";
        default: role_name = "UNKNOWN";
    }
    
    ZP_GameMode_GetInfo(g_current_gamemode, mode_name);
    
    new hp = get_user_health(id);
    new armor = get_user_armor(id);
    
    client_print(id, print_chat, "[ZP] Status:");
    client_print(id, print_chat, "[ZP] Role: %s | HP: %d | Armor: %d", role_name, hp, armor);
    client_print(id, print_chat, "[ZP] Mode: %s | Round: %d", mode_name, g_round_num);
    client_print(id, print_chat, "[ZP] Zombies: %d | Humans: %d", g_zombie_count, g_human_count);
    
    return PLUGIN_HANDLED;
}

// ==================== UTILITY FUNCTIONS ====================

static ZP_GameMode_GetInfo(gamemode_id, name[], len = 32) {
    switch(gamemode_id) {
        case GAMEMODE_INFECTION: copy(name, len, "Infection");
        case GAMEMODE_NEMESIS: copy(name, len, "Nemesis");
        case GAMEMODE_SURVIVOR: copy(name, len, "Survivor");
        case GAMEMODE_SNIPER: copy(name, len, "Sniper");
        case GAMEMODE_ASSASSIN: copy(name, len, "Assassin");
        case GAMEMODE_SWARM: copy(name, len, "Swarm");
        case GAMEMODE_MULTIPLE_INFECTION: copy(name, len, "Multiple Infection");
        case GAMEMODE_PLAGUE: copy(name, len, "Plague/Apocalypse");
        case GAMEMODE_ASSASSINS_VS_SNIPER: copy(name, len, "Assassins vs Sniper");
        case GAMEMODE_ARMAGEDDON: copy(name, len, "Armageddon");
        case GAMEMODE_DRAGON: copy(name, len, "Dragon");
        default: copy(name, len, "Unknown");
    }
}

// End of file
