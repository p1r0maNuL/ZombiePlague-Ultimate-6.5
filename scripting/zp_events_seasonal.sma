/*
 * Zombie Plague Ultimate 6.5 - Events & Seasonal System
 * 
 * File: zp_events_seasonal.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Event system (10+ events)
 * - Seasonal themes
 * - Holiday modes
 * - Limited-time rewards
 * - Event tracking and statistics
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

// ==================== EVENT DEFINITIONS ====================

enum Event {
    EV_ID,
    EV_NAME[32],
    EV_DESCRIPTION[64],
    EV_START_DATE[16],
    EV_END_DATE[16],
    EV_ACTIVE,
    EV_REWARD_XP,
    EV_REWARD_CREDITS,
    EV_BONUS_MULTIPLIER
};

// 10+ Special Events
static g_events[][Event] = {
    {0, "Double XP Weekend", "2x XP for all players", "FRI", "SUN", 1, 0, 0, 200},
    {1, "Triple Credits", "3x Credits earn rate", "WEEKLY", "WEEKLY", 1, 0, 0, 300},
    {2, "Halloween", "Spooky theme + special zombie", "OCT-01", "OCT-31", 0, 500, 1000, 150},
    {3, "Christmas", "Festive theme + bonus rewards", "DEC-15", "DEC-31", 0, 750, 1500, 200},
    {4, "New Year", "Fresh start event", "JAN-01", "JAN-07", 0, 500, 500, 150},
    {5, "Summer Madness", "Heat wave zombie mode", "JUN-01", "AUG-31", 0, 400, 800, 150},
    {6, "Easter Hunt", "Find hidden rewards", "SPRING", "SPRING", 0, 300, 600, 125},
    {7, "Anniversary Bash", "Server anniversary celebration", "MAY-15", "MAY-22", 0, 1000, 2000, 250},
    {8, "VIP Week", "VIP-only challenges", "MONTHLY", "MONTHLY", 1, 500, 1000, 175},
    {9, "Speedrun Challenge", "Race against time", "WEEKLY", "WEEKLY", 1, 400, 800, 150}
};

#define TOTAL_EVENTS 10

// ==================== SEASON DEFINITIONS ====================

enum Season {
    SS_NAME[32],
    SS_THEME[32],
    SS_COLOR[3],
    SS_ZOMBIES[32],
    SS_REWARDS_XP,
    SS_REWARDS_CREDITS
};

static g_seasons[][Season] = {
    {"Spring", "Nature", {0, 255, 0}, "Plant Zombies", 100, 200},
    {"Summer", "Heat", {255, 100, 0}, "Fire Zombies", 150, 300},
    {"Autumn", "Harvest", {255, 165, 0}, "Scarecrow Zombies", 120, 250},
    {"Winter", "Cold", {0, 200, 255}, "Frozen Zombies", 130, 260}
};

// ==================== GLOBALS ====================

new g_current_season = 0;
new g_event_active[TOTAL_EVENTS];
new g_player_event_progress[MAX_PLAYERS + 1][TOTAL_EVENTS];
new g_player_event_rewards[MAX_PLAYERS + 1][TOTAL_EVENTS];
new g_total_events_completed = 0;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Events & Seasonal", "6.5", "p1r0maNuL");
    
    // Register events
    register_event("HLTV", "event_round_start", "a");
    register_logevent("logevent_round_end", 2, "1=Round_End");
    
    // Register commands
    register_concmd("say /events", "cmd_show_events");
    register_concmd("say /season", "cmd_show_season");
    register_concmd("say /eventrewards", "cmd_show_event_rewards");
    register_concmd("say /eventinfo", "cmd_event_info");
    
    // Initialize events
    init_events();
    update_current_season();
    
    // Periodic tasks
    set_task(300.0, "task_update_events", 0, "", 0, "b");
    
    server_print("[ZP] Events & Seasonal System initialized!");
}

// ==================== INITIALIZATION ====================

public init_events() {
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        g_event_active[i] = g_events[i][EV_ACTIVE];
    }
}

public update_current_season() {
    new month = get_current_month();
    
    // Determine season based on month
    if(month >= 3 && month <= 5) {
        g_current_season = 0; // Spring
    } else if(month >= 6 && month <= 8) {
        g_current_season = 1; // Summer
    } else if(month >= 9 && month <= 11) {
        g_current_season = 2; // Autumn
    } else {
        g_current_season = 3; // Winter
    }
}

// ==================== EVENTS ====================

public event_round_start() {
    // Apply event bonuses
    apply_event_bonuses();
    
    // Show active events to players
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id)) {
            show_active_events(id);
        }
    }
}

public logevent_round_end() {
    // Update event progress
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id)) {
            check_event_completion(id);
        }
    }
}

public apply_event_bonuses() {
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        if(g_event_active[i]) {
            // Apply event-specific bonuses
            switch(i) {
                case 0: { // Double XP
                    set_cvar_num("zp_xp_multiplier", 2);
                    client_print(0, print_center, "EVENT: Double XP Active!");
                }
                case 1: { // Triple Credits
                    set_cvar_num("zp_credits_multiplier", 3);
                    client_print(0, print_center, "EVENT: Triple Credits Active!");
                }
            }
        }
    }
}

// ==================== EVENT COMMANDS ====================

public cmd_show_events(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "========== ACTIVE EVENTS ==========");
    
    new active_count = 0;
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        if(g_event_active[i]) {
            client_print(id, print_chat, "%d. %s",
                active_count + 1,
                g_events[i][EV_NAME]
            );
            active_count++;
        }
    }
    
    if(active_count == 0) {
        client_print(id, print_chat, "No active events");
    }
    
    client_print(id, print_chat, "===================================");
    
    return PLUGIN_HANDLED;
}

public cmd_show_season(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new season_name[32];
    new theme[32];
    new rewards_xp;
    new rewards_credits;
    
    copy(season_name, 31, g_seasons[g_current_season][SS_NAME]);
    copy(theme, 31, g_seasons[g_current_season][SS_THEME]);
    rewards_xp = g_seasons[g_current_season][SS_REWARDS_XP];
    rewards_credits = g_seasons[g_current_season][SS_REWARDS_CREDITS];
    
    client_print(id, print_chat, "========== CURRENT SEASON ==========");
    client_print(id, print_chat, "Season: %s", season_name);
    client_print(id, print_chat, "Theme: %s", theme);
    client_print(id, print_chat, "Bonus XP: +%d%%", rewards_xp);
    client_print(id, print_chat, "Bonus Credits: +%d%%", rewards_credits);
    client_print(id, print_chat, "===================================");
    
    return PLUGIN_HANDLED;
}

public cmd_show_event_rewards(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "========== YOUR EVENT REWARDS ==========");
    
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        if(g_player_event_rewards[id][i] > 0) {
            client_print(id, print_chat, "%s: %d rewards",
                g_events[i][EV_NAME],
                g_player_event_rewards[id][i]
            );
        }
    }
    
    client_print(id, print_chat, "========================================");
    
    return PLUGIN_HANDLED;
}

public cmd_event_info(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[32];
    read_args(args, 31);
    new event_id = str_to_num(args) - 1;
    
    if(event_id < 0 || event_id >= TOTAL_EVENTS) {
        client_print(id, print_chat, "[ZP] Usage: /eventinfo <event_id>");
        return PLUGIN_HANDLED;
    }
    
    client_print(id, print_chat, "========== EVENT INFO ==========");
    client_print(id, print_chat, "Name: %s", g_events[event_id][EV_NAME]);
    client_print(id, print_chat, "Description: %s", g_events[event_id][EV_DESCRIPTION]);
    client_print(id, print_chat, "XP Reward: %d", g_events[event_id][EV_REWARD_XP]);
    client_print(id, print_chat, "Credit Reward: %d", g_events[event_id][EV_REWARD_CREDITS]);
    client_print(id, print_chat, "Multiplier: %d%%", g_events[event_id][EV_BONUS_MULTIPLIER]);
    client_print(id, print_chat, "===============================");
    
    return PLUGIN_HANDLED;
}

// ==================== EVENT TRACKING ====================

public check_event_completion(id) {
    // Check if player completed event requirements
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        if(g_event_active[i]) {
            g_player_event_progress[id][i]++;
            
            // Award rewards
            if(g_player_event_progress[id][i] >= 10) {
                award_event_reward(id, i);
            }
        }
    }
}

public award_event_reward(id, event_id) {
    if(g_player_event_rewards[id][event_id] > 0)
        return; // Already awarded
    
    new xp_reward = g_events[event_id][EV_REWARD_XP];
    new credits_reward = g_events[event_id][EV_REWARD_CREDITS];
    
    add_player_xp(id, xp_reward);
    add_player_credits(id, credits_reward);
    
    g_player_event_rewards[id][event_id]++;
    
    new name[32];
    copy(name, 31, g_events[event_id][EV_NAME]);
    
    client_print(id, print_center, "EVENT COMPLETED: %s", name);
    client_print(id, print_chat, "[ZP] Reward: +%d XP, +$%d", xp_reward, credits_reward);
}

// ==================== PERIODIC UPDATES ====================

public task_update_events() {
    update_current_season();
    
    // Update event status
    new current_month = get_current_month();
    
    // Halloween event
    if(current_month == 10) {
        g_event_active[2] = 1;
    } else {
        g_event_active[2] = 0;
    }
    
    // Christmas event
    if(current_month == 12) {
        g_event_active[3] = 1;
    } else {
        g_event_active[3] = 0;
    }
    
    // New Year event
    if(current_month == 1) {
        g_event_active[4] = 1;
    } else {
        g_event_active[4] = 0;
    }
}

// ==================== SEASON BONUSES ====================

public get_season_xp_bonus() {
    return g_seasons[g_current_season][SS_REWARDS_XP];
}

public get_season_credits_bonus() {
    return g_seasons[g_current_season][SS_REWARDS_CREDITS];
}

public show_active_events(id) {
    new active_events = 0;
    
    for(new i = 0; i < TOTAL_EVENTS; i++) {
        if(g_event_active[i]) {
            active_events++;
        }
    }
    
    if(active_events > 0) {
        client_print(id, print_center, "%d active events! Use /events", active_events);
    }
}

// ==================== UTILITIES ====================

static get_current_month() {
    new timestamp = get_systime();
    new month = 0;
    
    // Simple month calculation (1-12)
    month = ((timestamp / 2592000) % 12) + 1;
    
    return month;
}

// ==================== NATIVES ====================

native add_player_xp(id, amount);
native add_player_credits(id, amount);

// End of file
