/*
 * Zombie Plague Ultimate 6.5 - Admin Tools System
 * 
 * File: zp_admin_tools.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Admin command system
 * - Player management (kick, ban, mute, freeze)
 * - Level/Credit manipulation
 * - VIP management
 * - Admin logging
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

#define ADMIN_LEVEL_MODERATOR 20
#define ADMIN_LEVEL_ADMIN 60
#define ADMIN_LEVEL_OWNER 100

// ==================== GLOBALS ====================

enum AdminLog {
    AL_TIMESTAMP,
    AL_ADMIN[32],
    AL_ACTION[64],
    AL_TARGET[32],
    AL_DETAILS[128]
};

new g_admin_logs[1000][AdminLog];
new g_admin_log_count = 0;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Admin Tools", "6.5", "p1r0maNuL");
    
    // Register admin commands
    register_concmd("amx_givexp", "cmd_give_xp");
    register_concmd("amx_givecredits", "cmd_give_credits");
    register_concmd("amx_slay", "cmd_slay_player");
    register_concmd("amx_freeze", "cmd_freeze_player");
    register_concmd("amx_unfreeze", "cmd_unfreeze_player");
    register_concmd("amx_mute", "cmd_mute_player");
    register_concmd("amx_unmute", "cmd_unmute_player");
    register_concmd("amx_setvip", "cmd_set_vip");
    register_concmd("amx_setlevel", "cmd_set_level");
    register_concmd("amx_adminlog", "cmd_show_admin_log");
    register_concmd("amx_reset", "cmd_reset_player");
    register_concmd("amx_kick", "cmd_kick_player");
    register_concmd("amx_ban", "cmd_ban_player");
    
    server_print("[ZP] Admin Tools System initialized!");
}

// ==================== ADMIN COMMANDS ====================

public cmd_give_xp(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_ADMIN, cid, 2))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    new xp_amount = read_argv(2, args, 255) ? str_to_num(args) : 0;
    
    if(!player_id || xp_amount <= 0) {
        console_print(id, "[ZP] Usage: amx_givexp <player> <xp>");
        return PLUGIN_HANDLED;
    }
    
    add_player_xp(player_id, xp_amount);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    client_print(player_id, print_chat, "[ZP] %s gave you %d XP!", admin_name, xp_amount);
    log_admin_action(id, "Give XP", player_id, xp_amount);
    
    return PLUGIN_HANDLED;
}

public cmd_give_credits(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_ADMIN, cid, 2))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    new credits_amount = read_argv(2, args, 255) ? str_to_num(args) : 0;
    
    if(!player_id || credits_amount <= 0) {
        console_print(id, "[ZP] Usage: amx_givecredits <player> <credits>");
        return PLUGIN_HANDLED;
    }
    
    add_player_credits(player_id, credits_amount);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    client_print(player_id, print_chat, "[ZP] %s gave you $%d!", admin_name, credits_amount);
    log_admin_action(id, "Give Credits", player_id, credits_amount);
    
    return PLUGIN_HANDLED;
}

public cmd_slay_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_ADMIN, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_slay <player>");
        return PLUGIN_HANDLED;
    }
    
    if(is_user_alive(player_id)) {
        user_kill(player_id);
        
        new admin_name[32], target_name[32];
        get_user_name(id, admin_name, 31);
        get_user_name(player_id, target_name, 31);
        
        client_print(0, print_chat, "[ZP] %s was slayed by %s", target_name, admin_name);
        log_admin_action(id, "Slay", player_id, 0);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_freeze_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_MODERATOR, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_freeze <player>");
        return PLUGIN_HANDLED;
    }
    
    if(is_user_connected(player_id)) {
        set_user_frozen(player_id, 1);
        
        new admin_name[32], target_name[32];
        get_user_name(id, admin_name, 31);
        get_user_name(player_id, target_name, 31);
        
        client_print(player_id, print_chat, "[ZP] You have been frozen by %s", admin_name);
        log_admin_action(id, "Freeze", player_id, 0);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_unfreeze_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_MODERATOR, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_unfreeze <player>");
        return PLUGIN_HANDLED;
    }
    
    if(is_user_connected(player_id)) {
        set_user_frozen(player_id, 0);
        
        new admin_name[32], target_name[32];
        get_user_name(id, admin_name, 31);
        get_user_name(player_id, target_name, 31);
        
        client_print(player_id, print_chat, "[ZP] You have been unfrozen by %s", admin_name);
        log_admin_action(id, "Unfreeze", player_id, 0);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_mute_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_MODERATOR, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_mute <player>");
        return PLUGIN_HANDLED;
    }
    
    if(is_user_connected(player_id)) {
        set_user_muted(player_id, 1);
        
        new admin_name[32], target_name[32];
        get_user_name(id, admin_name, 31);
        get_user_name(player_id, target_name, 31);
        
        client_print(0, print_chat, "[ZP] %s has been muted by %s", target_name, admin_name);
        log_admin_action(id, "Mute", player_id, 0);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_unmute_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_MODERATOR, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_unmute <player>");
        return PLUGIN_HANDLED;
    }
    
    if(is_user_connected(player_id)) {
        set_user_muted(player_id, 0);
        
        new admin_name[32], target_name[32];
        get_user_name(id, admin_name, 31);
        get_user_name(player_id, target_name, 31);
        
        client_print(player_id, print_chat, "[ZP] You have been unmuted by %s", admin_name);
        log_admin_action(id, "Unmute", player_id, 0);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_set_vip(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_OWNER, cid, 2))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    new vip_tier = read_argv(2, args, 255) ? str_to_num(args) : 0;
    
    if(!player_id || vip_tier < 0 || vip_tier > 5) {
        console_print(id, "[ZP] Usage: amx_setvip <player> <tier 0-5>");
        return PLUGIN_HANDLED;
    }
    
    set_player_vip(player_id, vip_tier, 30);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    if(vip_tier > 0) {
        client_print(player_id, print_chat, "[ZP] You have been set to VIP %d by %s", vip_tier, admin_name);
    } else {
        client_print(player_id, print_chat, "[ZP] Your VIP has been removed by %s", admin_name);
    }
    
    log_admin_action(id, "Set VIP", player_id, vip_tier);
    
    return PLUGIN_HANDLED;
}

public cmd_set_level(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_OWNER, cid, 2))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    new new_level = read_argv(2, args, 255) ? str_to_num(args) : 0;
    
    if(!player_id || new_level < 1 || new_level > 100) {
        console_print(id, "[ZP] Usage: amx_setlevel <player> <level 1-100>");
        return PLUGIN_HANDLED;
    }
    
    set_player_level(player_id, new_level);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    client_print(player_id, print_chat, "[ZP] Your level has been set to %d by %s", new_level, admin_name);
    log_admin_action(id, "Set Level", player_id, new_level);
    
    return PLUGIN_HANDLED;
}

public cmd_reset_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_OWNER, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_reset <player>");
        return PLUGIN_HANDLED;
    }
    
    set_player_level(player_id, 1);
    set_player_credits(player_id, 0);
    set_player_vip(player_id, 0, 0);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    client_print(player_id, print_chat, "[ZP] Your account has been reset by %s", admin_name);
    log_admin_action(id, "Reset Account", player_id, 0);
    
    return PLUGIN_HANDLED;
}

public cmd_kick_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_ADMIN, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_kick <player>");
        return PLUGIN_HANDLED;
    }
    
    new reason[64] = "Admin kick";
    read_argv(2, reason, 63);
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    server_cmd("kick #%d \"%s\"", get_user_userid(player_id), reason);
    
    log_admin_action(id, "Kick", player_id, 0);
    
    return PLUGIN_HANDLED;
}

public cmd_ban_player(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_OWNER, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[256];
    read_args(args, 255);
    
    new player_id = cmd_target(id, args, 1);
    
    if(!player_id) {
        console_print(id, "[ZP] Usage: amx_ban <player>");
        return PLUGIN_HANDLED;
    }
    
    new steamid[MAX_STEAMID_LENGTH];
    get_user_authid(player_id, steamid, MAX_STEAMID_LENGTH - 1);
    
    new reason[64] = "Admin ban";
    read_argv(2, reason, 63);
    
    server_cmd("banid 0 %s kick", steamid);
    server_cmd("writeid");
    
    new admin_name[32], target_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player_id, target_name, 31);
    
    client_print(0, print_chat, "[ZP] %s has been banned by %s", target_name, admin_name);
    log_admin_action(id, "Ban", player_id, 0);
    
    return PLUGIN_HANDLED;
}

public cmd_show_admin_log(id, level, cid) {
    if(!cmd_access(id, ADMIN_LEVEL_ADMIN, cid, 0))
        return PLUGIN_HANDLED;
    
    console_print(id, "========== ADMIN LOG ==========");
    console_print(id, "Showing last 20 actions:");
    
    new start = max(0, g_admin_log_count - 20);
    
    for(new i = start; i < g_admin_log_count; i++) {
        console_print(id, "[%s] %s -> %s (%s)",
            g_admin_logs[i][AL_ADMIN],
            g_admin_logs[i][AL_ACTION],
            g_admin_logs[i][AL_TARGET],
            g_admin_logs[i][AL_DETAILS]
        );
    }
    
    console_print(id, "=============================");
    
    return PLUGIN_HANDLED;
}

// ==================== LOGGING ====================

public log_admin_action(admin_id, action[], target_id, value) {
    if(g_admin_log_count >= 999)
        return;
    
    new admin_name[32], target_name[32];
    get_user_name(admin_id, admin_name, 31);
    get_user_name(target_id, target_name, 31);
    
    g_admin_logs[g_admin_log_count][AL_TIMESTAMP] = get_systime();
    copy(g_admin_logs[g_admin_log_count][AL_ADMIN], 31, admin_name);
    copy(g_admin_logs[g_admin_log_count][AL_ACTION], 63, action);
    copy(g_admin_logs[g_admin_log_count][AL_TARGET], 31, target_name);
    format(g_admin_logs[g_admin_log_count][AL_DETAILS], 127, "Value: %d", value);
    
    g_admin_log_count++;
}

// ==================== NATIVES ====================

native add_player_xp(id, amount);
native add_player_credits(id, amount);
native set_player_level(id, level);
native set_player_credits(id, amount);
native set_player_vip(id, tier, days);
native set_user_frozen(id, frozen);
native set_user_muted(id, muted);

// End of file
