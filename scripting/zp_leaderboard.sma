/*
 * Zombie Plague Ultimate 6.5 - Leaderboard Display
 * 
 * File: zp_leaderboard.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Leaderboard calculation and display
 * - Player rankings
 * - Top players tracking
 * - Stats persistence
 */

#include <amxmodx>
#include <amxmisc>

// ==================== GLOBALS ====================

enum PlayerRank {
    PR_NAME[32],
    PR_LEVEL,
    PR_XP,
    PR_CREDITS,
    PR_KILLS,
    PR_ACHIEVEMENTS,
    PR_PLAYTIME
};

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Leaderboard", "6.5", "p1r0maNuL");
    
    // Register commands
    register_concmd("say /top", "cmd_show_top_players");
    register_concmd("say /rank", "cmd_show_player_rank");
    register_concmd("say /top10", "cmd_show_top_10");
    
    server_print("[ZP] Leaderboard System initialized!");
}

// ==================== COMMANDS ====================

public cmd_show_top_players(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_top_leaderboard(id, 5);
    
    return PLUGIN_HANDLED;
}

public cmd_show_top_10(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_top_leaderboard(id, 10);
    
    return PLUGIN_HANDLED;
}

public cmd_show_player_rank(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new rank_name[32];
    new rank_color[32];
    new player_level = get_player_level(id);
    
    // Determine rank based on level
    if(player_level < 10) {
        copy(rank_name, 31, "Novice");
        copy(rank_color, 31, "\r");
    } else if(player_level < 25) {
        copy(rank_name, 31, "Apprentice");
        copy(rank_color, 31, "\g");
    } else if(player_level < 50) {
        copy(rank_name, 31, "Expert");
        copy(rank_color, 31, "\y");
    } else if(player_level < 100) {
        copy(rank_name, 31, "Master");
        copy(rank_color, 31, "\w");
    } else {
        copy(rank_name, 31, "Legendary");
        copy(rank_color, 31, "\d");
    }
    
    client_print(id, print_chat, "Your Rank: %s%s", rank_color, rank_name);
    
    return PLUGIN_HANDLED;
}

public show_top_leaderboard(id, limit) {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new leaderboard[MAX_PLAYERS][PlayerRank];
    
    // Collect player data
    for(new i = 0; i < count; i++) {
        new pid = players[i];
        get_user_name(pid, leaderboard[i][PR_NAME], 31);
        leaderboard[i][PR_LEVEL] = get_player_level(pid);
        leaderboard[i][PR_XP] = get_player_xp(pid);
        leaderboard[i][PR_CREDITS] = get_player_credits(pid);
        leaderboard[i][PR_KILLS] = get_player_kills(pid);
    }
    
    // Sort by level (descending)
    for(new i = 0; i < count - 1; i++) {
        for(new j = i + 1; j < count; j++) {
            if(leaderboard[j][PR_LEVEL] > leaderboard[i][PR_LEVEL]) {
                new temp[PlayerRank];
                arraycopy(temp, 0, leaderboard[i], 0, sizeof(PlayerRank));
                arraycopy(leaderboard[i], 0, leaderboard[j], 0, sizeof(PlayerRank));
                arraycopy(leaderboard[j], 0, temp, 0, sizeof(PlayerRank));
            }
        }
    }
    
    client_print(id, print_chat, "========== TOP %d PLAYERS ==========", limit);
    client_print(id, print_chat, "Rank | Name | Level | XP");
    
    for(new i = 0; i < limit && i < count; i++) {
        client_print(id, print_chat, "#%d | %s | Lv.%d | %d XP",
            i + 1,
            leaderboard[i][PR_NAME],
            leaderboard[i][PR_LEVEL],
            leaderboard[i][PR_XP]
        );
    }
    
    client_print(id, print_chat, "===================================");
}

// ==================== NATIVES ====================

native get_player_level(id);
native get_player_xp(id);
native get_player_credits(id);
native get_player_kills(id);

// End of file
