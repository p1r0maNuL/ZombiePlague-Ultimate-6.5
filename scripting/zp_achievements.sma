/*
 * Zombie Plague Ultimate 6.5 - Achievements System
 * 
 * File: zp_achievements.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - 50+ Achievements
 * - Achievement unlock logic
 * - Badges and rewards
 * - Statistics tracking
 * - Leaderboard
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

// ==================== ACHIEVEMENT DEFINITIONS ====================

enum Achievement {
    ACH_ID,
    ACH_NAME[32],
    ACH_DESCRIPTION[64],
    ACH_ICON,
    ACH_REWARD_XP,
    ACH_REWARD_CREDITS
};

// 50 Achievements
static g_achievements[][Achievement] = {
    // Kills achievements
    {0, "First Blood", "Get your first kill", 1, 50, 100},
    {1, "Killer", "Get 10 kills", 1, 100, 200},
    {2, "Assassin", "Get 50 kills", 1, 200, 400},
    {3, "Massacre", "Get 100 kills", 1, 300, 600},
    {4, "Legendary", "Get 500 kills", 1, 500, 1000},
    
    // Headshot achievements
    {5, "Sharpshooter", "Get 5 headshots", 2, 75, 150},
    {6, "Marksman", "Get 25 headshots", 2, 150, 300},
    {7, "Sniper Pro", "Get 100 headshots", 2, 300, 600},
    
    // Infection achievements
    {8, "Patient Zero", "Infect your first human", 3, 50, 100},
    {9, "Plague Spreader", "Infect 10 humans", 3, 100, 200},
    {10, "Epidemic", "Infect 50 humans", 3, 200, 400},
    
    // Survival achievements
    {11, "Survivor", "Survive 1 round", 4, 50, 100},
    {12, "Tank", "Survive 5 rounds", 4, 100, 200},
    {13, "Last Man Standing", "Survive 10 rounds", 4, 200, 400},
    {14, "Immortal", "Survive 25 rounds", 4, 400, 800},
    
    // Damage achievements
    {15, "Scratch", "Deal 1000 damage", 5, 50, 100},
    {16, "Bruiser", "Deal 10000 damage", 5, 100, 200},
    {17, "Destroyer", "Deal 50000 damage", 5, 200, 400},
    {18, "Annihilator", "Deal 500000 damage", 5, 500, 1000},
    
    // XP achievements
    {19, "Novice", "Reach level 10", 6, 100, 200},
    {20, "Expert", "Reach level 25", 6, 200, 400},
    {21, "Master", "Reach level 50", 6, 300, 600},
    {22, "Legendary Player", "Reach level 100", 6, 500, 1000},
    
    // Credits achievements
    {23, "Rich", "Earn 10000 credits", 7, 75, 150},
    {24, "Wealthy", "Earn 100000 credits", 7, 150, 300},
    {25, "Millionaire", "Earn 1000000 credits", 7, 300, 600},
    
    // Class achievements
    {26, "Zombie Expert", "Unlock all zombie classes", 8, 200, 400},
    {27, "Human Expert", "Unlock all human classes", 8, 200, 400},
    {28, "Class Master", "Unlock all 48 classes", 8, 500, 1000},
    
    // VIP achievements
    {29, "VIP Member", "Purchase VIP 1", 9, 100, 200},
    {30, "VIP Elite", "Purchase VIP 3 or higher", 9, 200, 400},
    {31, "VIP Legend", "Purchase VIP 5", 9, 300, 600},
    
    // Speed achievements
    {32, "Speed Demon", "Kill 5 zombies in 1 round", 10, 100, 200},
    {33, "Rampage", "Kill 10 zombies in 1 round", 10, 200, 400},
    {34, "Unstoppable", "Kill 25 zombies in 1 round", 10, 400, 800},
    
    // Game mode achievements
    {35, "Infection Survivor", "Win Infection mode 5 times", 11, 100, 200},
    {36, "Nemesis Slayer", "Kill Nemesis 3 times", 11, 150, 300},
    {37, "Survivor Master", "Reach round 5 as Survivor", 11, 150, 300},
    {38, "Swarm Beater", "Win Swarm mode once", 11, 200, 400},
    
    // Playtime achievements
    {39, "Welcome", "Play for 1 hour", 12, 50, 100},
    {40, "Dedicated", "Play for 10 hours", 12, 100, 200},
    {41, "Veteran", "Play for 50 hours", 12, 200, 400},
    {42, "Legend", "Play for 100 hours", 12, 300, 600},
    {43, "Immortal Player", "Play for 500 hours", 12, 500, 1000},
    
    // Special achievements
    {44, "Shop Lover", "Spend 50000 credits in shop", 13, 100, 200},
    {45, "Gambler", "Spin slot machine 50 times", 13, 100, 200},
    {46, "Lucky", "Win jackpot in slot machine", 13, 200, 400},
    {47, "Daily Visitor", "Claim daily bonus 7 days", 13, 100, 200},
    {48, "Unstoppable Force", "Get 3 kills without dying", 14, 200, 400},
    {49, "Untouchable", "Complete round without taking damage", 14, 300, 600}
};

#define TOTAL_ACHIEVEMENTS 50

// ==================== GLOBALS ====================

new g_player_achievements[MAX_PLAYERS + 1][TOTAL_ACHIEVEMENTS];
new g_player_achievement_progress[MAX_PLAYERS + 1][TOTAL_ACHIEVEMENTS];

// Statistics tracking
new g_player_kills[MAX_PLAYERS + 1];
new g_player_headshots[MAX_PLAYERS + 1];
new g_player_infects[MAX_PLAYERS + 1];
new g_player_rounds_survived[MAX_PLAYERS + 1];
new g_player_total_damage[MAX_PLAYERS + 1];
new g_player_round_kills[MAX_PLAYERS + 1];
new g_player_consecutive_kills[MAX_PLAYERS + 1];

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Achievements", "6.5", "p1r0maNuL");
    
    // Register events
    register_logevent("logevent_player_kill", 2, "1=killed");
    register_event("HLTV", "event_round_start", "a");
    register_logevent("logevent_round_end", 2, "1=Round_End");
    
    // Register commands
    register_concmd("say /achievements", "cmd_show_achievements");
    register_concmd("say /achlist", "cmd_show_achievements");
    register_concmd("say /leaderboard", "cmd_show_leaderboard");
    register_concmd("say /stats", "cmd_show_stats");
    
    server_print("[ZP] Achievements System initialized!");
}

// ==================== EVENTS ====================

public logevent_player_kill() {
    new attacker_id = read_logdata(1);
    new victim_id = read_logdata(2);
    new headshot = read_logdata(3);
    
    if(!is_user_connected(attacker_id) || !is_user_connected(victim_id))
        return;
    
    if(attacker_id == victim_id)
        return;
    
    // Track kills
    g_player_kills[attacker_id]++;
    g_player_round_kills[attacker_id]++;
    g_player_consecutive_kills[attacker_id]++;
    
    if(headshot) {
        g_player_headshots[attacker_id]++;
    }
    
    // Check achievements
    check_kill_achievements(attacker_id);
}

public event_round_start() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id)) {
            g_player_round_kills[id] = 0;
            g_player_consecutive_kills[id] = 0;
        }
    }
}

public logevent_round_end() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id)) {
            g_player_rounds_survived[id]++;
            
            // Check round achievements
            check_round_achievements(id);
        }
    }
}

// ==================== ACHIEVEMENT CHECKING ====================

public check_kill_achievements(id) {
    // Kill achievements
    if(g_player_kills[id] == 1)
        unlock_achievement(id, 0); // First Blood
    else if(g_player_kills[id] == 10)
        unlock_achievement(id, 1); // Killer
    else if(g_player_kills[id] == 50)
        unlock_achievement(id, 2); // Assassin
    else if(g_player_kills[id] == 100)
        unlock_achievement(id, 3); // Massacre
    else if(g_player_kills[id] == 500)
        unlock_achievement(id, 4); // Legendary
    
    // Headshot achievements
    if(g_player_headshots[id] == 5)
        unlock_achievement(id, 5); // Sharpshooter
    else if(g_player_headshots[id] == 25)
        unlock_achievement(id, 6); // Marksman
    else if(g_player_headshots[id] == 100)
        unlock_achievement(id, 7); // Sniper Pro
    
    // Speed achievements
    if(g_player_round_kills[id] == 5)
        unlock_achievement(id, 32); // Speed Demon
    else if(g_player_round_kills[id] == 10)
        unlock_achievement(id, 33); // Rampage
    else if(g_player_round_kills[id] == 25)
        unlock_achievement(id, 34); // Unstoppable
}

public check_round_achievements(id) {
    // Survival achievements
    if(g_player_rounds_survived[id] == 1)
        unlock_achievement(id, 11); // Survivor
    else if(g_player_rounds_survived[id] == 5)
        unlock_achievement(id, 12); // Tank
    else if(g_player_rounds_survived[id] == 10)
        unlock_achievement(id, 13); // Last Man Standing
    else if(g_player_rounds_survived[id] == 25)
        unlock_achievement(id, 14); // Immortal
}

// ==================== UNLOCK ACHIEVEMENT ====================

public unlock_achievement(id, ach_id) {
    if(ach_id < 0 || ach_id >= TOTAL_ACHIEVEMENTS)
        return;
    
    // Already unlocked?
    if(g_player_achievements[id][ach_id])
        return;
    
    // Unlock achievement
    g_player_achievements[id][ach_id] = 1;
    
    // Award rewards
    new xp_reward = g_achievements[ach_id][ACH_REWARD_XP];
    new credits_reward = g_achievements[ach_id][ACH_REWARD_CREDITS];
    
    add_player_xp(id, xp_reward);
    add_player_credits(id, credits_reward);
    
    // Notify player
    new ach_name[32];
    copy(ach_name, 31, g_achievements[ach_id][ACH_NAME]);
    
    client_print(id, print_center, "ACHIEVEMENT UNLOCKED: %s", ach_name);
    client_print(id, print_chat, "[ZP] Achievement: %s (+%d XP, +$%d)", ach_name, xp_reward, credits_reward);
}

// ==================== COMMANDS ====================

public cmd_show_achievements(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new unlocked_count = 0;
    
    for(new i = 0; i < TOTAL_ACHIEVEMENTS; i++) {
        if(g_player_achievements[id][i])
            unlocked_count++;
    }
    
    new progress = (unlocked_count * 100) / TOTAL_ACHIEVEMENTS;
    
    client_print(id, print_chat, "========== YOUR ACHIEVEMENTS ==========");
    client_print(id, print_chat, "Unlocked: %d / %d (%d%%)", unlocked_count, TOTAL_ACHIEVEMENTS, progress);
    client_print(id, print_chat, "========================================");
    
    // Show first 5 achievements
    for(new i = 0; i < 5; i++) {
        new status[16];
        copy(status, 15, g_player_achievements[id][i] ? "[✓]" : "[✗]");
        
        client_print(id, print_chat, "%s %s - %s", status, g_achievements[i][ACH_NAME], g_achievements[i][ACH_DESCRIPTION]);
    }
    
    client_print(id, print_chat, "... and %d more", TOTAL_ACHIEVEMENTS - 5);
    
    return PLUGIN_HANDLED;
}

public cmd_show_leaderboard(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new board_data[MAX_PLAYERS][2]; // [achievements_unlocked, player_id]
    
    for(new i = 0; i < count; i++) {
        new pid = players[i];
        new unlocked = 0;
        
        for(new j = 0; j < TOTAL_ACHIEVEMENTS; j++) {
            if(g_player_achievements[pid][j])
                unlocked++;
        }
        
        board_data[i][0] = unlocked;
        board_data[i][1] = pid;
    }
    
    // Sort leaderboard (descending)
    for(new i = 0; i < count - 1; i++) {
        for(new j = i + 1; j < count; j++) {
            if(board_data[j][0] > board_data[i][0]) {
                new temp_ach = board_data[i][0];
                new temp_id = board_data[i][1];
                board_data[i][0] = board_data[j][0];
                board_data[i][1] = board_data[j][1];
                board_data[j][0] = temp_ach;
                board_data[j][1] = temp_id;
            }
        }
    }
    
    client_print(id, print_chat, "========== ACHIEVEMENT LEADERBOARD ==========");
    
    for(new i = 0; i < count && i < 10; i++) {
        new pid = board_data[i][1];
        new pname[32];
        get_user_name(pid, pname, 31);
        
        client_print(id, print_chat, "%d. %s - %d achievements", i + 1, pname, board_data[i][0]);
    }
    
    client_print(id, print_chat, "===========================================");
    
    return PLUGIN_HANDLED;
}

public cmd_show_stats(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "========== YOUR STATISTICS ==========");
    client_print(id, print_chat, "Total Kills: %d", g_player_kills[id]);
    client_print(id, print_chat, "Headshots: %d", g_player_headshots[id]);
    client_print(id, print_chat, "Humans Infected: %d", g_player_infects[id]);
    client_print(id, print_chat, "Rounds Survived: %d", g_player_rounds_survived[id]);
    client_print(id, print_chat, "Total Damage: %d", g_player_total_damage[id]);
    client_print(id, print_chat, "=====================================");
    
    return PLUGIN_HANDLED;
}

// ==================== NATIVES ====================

native add_player_xp(id, amount);
native add_player_credits(id, amount);

// End of file
