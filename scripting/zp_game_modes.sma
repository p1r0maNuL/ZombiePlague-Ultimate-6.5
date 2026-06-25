/*
 * Zombie Plague Ultimate 6.5 - Game Modes System
 * 
 * File: zp_game_modes.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - 5 Game modes (Infection, Survivor, Nemesis, Swarm, Plague)
 * - Mode switching logic
 * - Mode-specific rules and objectives
 * - Mode selection and voting
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

#define MODE_INFECTION 1
#define MODE_SURVIVOR 2
#define MODE_NEMESIS 3
#define MODE_SWARM 4
#define MODE_PLAGUE 5

// ==================== GAME MODE INFO ====================

enum GameMode {
    GM_ID,
    GM_NAME[32],
    GM_DESCRIPTION[64],
    GM_MIN_PLAYERS,
    GM_ZOMBIE_COUNT,
    GM_SPECIAL_RULES[128]
};

static g_game_modes[][GameMode] = {
    {MODE_INFECTION, "Infection", "One starts as zombie, infects humans", 4, 1, "Zombie multiplies each round"},
    {MODE_SURVIVOR, "Survivor", "Humans must survive against all zombies", 6, 3, "Fixed zombie count per round"},
    {MODE_NEMESIS, "Nemesis", "One powerful zombie vs many humans", 5, 1, "Nemesis has 5000 HP + special abilities"},
    {MODE_SWARM, "Swarm", "Endless zombie waves, survive as long as possible", 4, 5, "Zombie waves increase each round"},
    {MODE_PLAGUE, "Plague", "Plague zombie spreads infection rapidly", 6, 2, "Plague zombies multiply faster"}
};

#define TOTAL_MODES 5

// ==================== GLOBALS ====================

new g_current_mode = MODE_INFECTION;
new g_next_mode = MODE_INFECTION;
new g_mode_votes[TOTAL_MODES + 1];
new g_mode_voting = 0;
new g_round_count = 0;
new g_infection_count = 0;

// Mode-specific tracking
new g_nemesis_hp = 5000;
new g_swarm_wave = 0;
new g_plague_spread_rate = 150; // % of infection rate

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Game Modes", "6.5", "p1r0maNuL");
    
    // Register events
    register_logevent("logevent_round_start", 2, "1=Round_Start");
    register_logevent("logevent_round_end", 2, "1=Round_End");
    register_event("HLTV", "event_round_begin", "a");
    
    // Register commands
    register_concmd("say /modes", "cmd_show_modes");
    register_concmd("say /currentmode", "cmd_show_current_mode");
    register_concmd("say /modevote", "cmd_vote_mode");
    register_concmd("say /nextmode", "cmd_show_next_mode");
    
    // Initialize
    g_current_mode = MODE_INFECTION;
    
    server_print("[ZP] Game Modes System initialized!");
}

// ==================== EVENTS ====================

public logevent_round_start() {
    g_round_count++;
    g_infection_count = 0;
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    // Initialize game mode
    switch(g_current_mode) {
        case MODE_INFECTION: {
            init_infection_mode(players, count);
        }
        case MODE_SURVIVOR: {
            init_survivor_mode(players, count);
        }
        case MODE_NEMESIS: {
            init_nemesis_mode(players, count);
        }
        case MODE_SWARM: {
            init_swarm_mode(players, count);
        }
        case MODE_PLAGUE: {
            init_plague_mode(players, count);
        }
    }
}

public logevent_round_end() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new zombies = 0;
    new humans = 0;
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_zombie(id)) {
            zombies++;
        } else {
            humans++;
        }
    }
    
    // Check round winner
    if(zombies > 0 && humans == 0) {
        client_print(0, print_center, "ZOMBIES WIN!");
    } else if(humans > 0 && zombies == 0) {
        client_print(0, print_center, "HUMANS WIN!");
    }
    
    // Mode-specific end logic
    switch(g_current_mode) {
        case MODE_SWARM: {
            g_swarm_wave++;
            client_print(0, print_center, "Wave %d completed!", g_swarm_wave);
        }
    }
}

public event_round_begin() {
    // Check if mode needs to change
    if(g_next_mode != g_current_mode && g_round_count >= 3) {
        g_current_mode = g_next_mode;
        client_print(0, print_center, "Game mode changed to %s", get_mode_name(g_current_mode));
    }
}

// ==================== GAME MODE INITIALIZATION ====================

public init_infection_mode(players[], count) {
    client_print(0, print_center, "MODE: INFECTION");
    client_print(0, print_chat, "[ZP] One zombie starts. Infect all humans!");
    
    // Select random zombie
    new zombie_id = players[random(count)];
    set_user_zombie(zombie_id, 1);
    
    client_print(zombie_id, print_center, "You are the first zombie!");
    client_print(0, print_chat, "[ZP] Patient Zero selected!");
}

public init_survivor_mode(players[], count) {
    client_print(0, print_center, "MODE: SURVIVOR");
    client_print(0, print_chat, "[ZP] 3 zombies vs humans. Humans must survive!");
    
    new mode_idx = 1;
    new zombie_count = g_game_modes[mode_idx][GM_ZOMBIE_COUNT];
    
    // Select random zombies
    for(new i = 0; i < zombie_count && i < count; i++) {
        new zombie_id = players[random(count)];
        if(!is_user_zombie(zombie_id)) {
            set_user_zombie(zombie_id, 1);
        }
    }
    
    client_print(0, print_chat, "[ZP] %d zombies selected!", zombie_count);
}

public init_nemesis_mode(players[], count) {
    client_print(0, print_center, "MODE: NEMESIS");
    client_print(0, print_chat, "[ZP] One powerful zombie vs many humans!");
    
    // Select random nemesis
    new nemesis_id = players[random(count)];
    set_user_zombie(nemesis_id, 1);
    
    // Give nemesis special abilities
    g_nemesis_hp = 5000;
    set_user_health(nemesis_id, g_nemesis_hp);
    set_user_speed(nemesis_id, 400);
    
    client_print(nemesis_id, print_center, "You are NEMESIS!");
    client_print(nemesis_id, print_chat, "[ZP] Nemesis - 5000 HP, 400 speed, 2x damage!");
}

public init_swarm_mode(players[], count) {
    client_print(0, print_center, "MODE: SWARM");
    client_print(0, print_chat, "[ZP] Zombie waves! Survive as long as possible!");
    
    new wave_zombies = 5 + g_swarm_wave;
    
    // Select zombies based on wave
    for(new i = 0; i < wave_zombies && i < count; i++) {
        new zombie_id = players[random(count)];
        if(!is_user_zombie(zombie_id)) {
            set_user_zombie(zombie_id, 1);
        }
    }
    
    client_print(0, print_chat, "[ZP] Wave %d: %d zombies!", g_swarm_wave + 1, wave_zombies);
}

public init_plague_mode(players[], count) {
    client_print(0, print_center, "MODE: PLAGUE");
    client_print(0, print_chat, "[ZP] Plague spreads rapidly! Stop the infection!");
    
    // Select random plague zombies
    for(new i = 0; i < 2 && i < count; i++) {
        new zombie_id = players[random(count)];
        if(!is_user_zombie(zombie_id)) {
            set_user_zombie(zombie_id, 1);
            // Mark as plague zombie
            set_user_plague(zombie_id, 1);
        }
    }
    
    client_print(0, print_chat, "[ZP] 2 Plague zombies selected! They spread faster!");
}

// ==================== COMMANDS ====================

public cmd_show_modes(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "========== GAME MODES ==========");
    
    for(new i = 0; i < TOTAL_MODES; i++) {
        client_print(id, print_chat, "%d. %s - %s",
            i + 1,
            g_game_modes[i][GM_NAME],
            g_game_modes[i][GM_DESCRIPTION]
        );
    }
    
    client_print(id, print_chat, "===============================");
    
    return PLUGIN_HANDLED;
}

public cmd_show_current_mode(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new mode_name[32];
    copy(mode_name, 31, get_mode_name(g_current_mode));
    
    client_print(id, print_chat, "[ZP] Current mode: %s (Round %d)", mode_name, g_round_count);
    
    return PLUGIN_HANDLED;
}

public cmd_show_next_mode(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new next_name[32];
    copy(next_name, 31, get_mode_name(g_next_mode));
    
    client_print(id, print_chat, "[ZP] Next mode: %s (in 3 rounds)", next_name);
    
    return PLUGIN_HANDLED;
}

public cmd_vote_mode(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[32];
    read_args(args, 31);
    
    new mode_id = str_to_num(args);
    
    if(mode_id < 1 || mode_id > TOTAL_MODES) {
        client_print(id, print_chat, "[ZP] Usage: /modevote <mode 1-5>");
        return PLUGIN_HANDLED;
    }
    
    g_mode_votes[mode_id]++;
    
    new mode_name[32];
    copy(mode_name, 31, g_game_modes[mode_id - 1][GM_NAME]);
    
    client_print(0, print_chat, "[ZP] %N voted for %s", id, mode_name);
    
    // Check if mode should change
    check_mode_votes();
    
    return PLUGIN_HANDLED;
}

// ==================== MODE UTILITIES ====================

public check_mode_votes() {
    new max_votes = 0;
    new winning_mode = 1;
    
    for(new i = 1; i <= TOTAL_MODES; i++) {
        if(g_mode_votes[i] > max_votes) {
            max_votes = g_mode_votes[i];
            winning_mode = i;
        }
    }
    
    // Change mode if enough votes
    if(max_votes >= 3) {
        g_next_mode = winning_mode;
        
        new mode_name[32];
        copy(mode_name, 31, g_game_modes[winning_mode - 1][GM_NAME]);
        
        client_print(0, print_center, "Mode will change to %s", mode_name);
        
        // Reset votes
        for(new i = 0; i <= TOTAL_MODES; i++) {
            g_mode_votes[i] = 0;
        }
    }
}

public get_mode_name(mode_id[]) {
    static name[32];
    
    for(new i = 0; i < TOTAL_MODES; i++) {
        if(g_game_modes[i][GM_ID] == mode_id) {
            copy(name, 31, g_game_modes[i][GM_NAME]);
            return name;
        }
    }
    
    return "Unknown";
}

// ==================== NATIVES ====================

native set_user_zombie(id, zombie);
native is_user_zombie(id);
native set_user_speed(id, speed);
native set_user_plague(id, plague);

// End of file
