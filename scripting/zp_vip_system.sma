/*
 * Zombie Plague Ultimate 6.5 - VIP System
 * 
 * File: zp_vip_system.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - VIP tier system (VIP1-VIP5)
 * - VIP benefits and bonuses
 * - VIP-only commands and features
 * - VIP rewards and privileges
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

#define VIP_NONE 0
#define VIP_TIER_1 1
#define VIP_TIER_2 2
#define VIP_TIER_3 3
#define VIP_TIER_4 4
#define VIP_TIER_5 5

// ==================== GLOBALS ====================

new g_player_vip_tier[MAX_PLAYERS + 1];
new g_player_vip_expire[MAX_PLAYERS + 1];

// VIP Tier Info
enum VIPTier {
    VT_NAME[32],
    VT_COLOR[3],
    VT_XP_BONUS,      // % bonus
    VT_CREDITS_BONUS, // % bonus
    VT_HP_BONUS,
    VT_SPEED_BONUS,
    VT_PRICE,         // Cost to buy
    VT_DURATION       // Days
};

static g_vip_tiers[][VIPTier] = {
    {"VIP 1", {0, 255, 0}, 10, 10, 100, 50, 5000, 30},
    {"VIP 2", {0, 255, 255}, 20, 20, 200, 100, 15000, 30},
    {"VIP 3", {255, 255, 0}, 30, 30, 300, 150, 30000, 30},
    {"VIP 4", {255, 100, 0}, 40, 40, 400, 200, 50000, 30},
    {"VIP 5", {255, 0, 255}, 50, 50, 500, 250, 100000, 30}
};

new cvar_vip_enabled;
new cvar_vip_xp_bonus;
new cvar_vip_credits_bonus;

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - VIP System", "6.5", "p1r0maNuL");
    
    // Register events
    register_logevent("logevent_player_connect", 2, "1=player_connect");
    register_event("HLTV", "event_round_start", "a");
    
    // Register commands
    register_concmd("say /vip", "cmd_show_vip_info");
    register_concmd("say /buyvip", "cmd_buyvip");
    register_concmd("say /vipshop", "cmd_vip_shop");
    register_concmd("say /vipstatus", "cmd_vip_status");
    register_concmd("say /viplist", "cmd_vip_list");
    
    // Register menu handlers
    register_menucmd(register_menuid("VIP Shop Menu"), (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5), "handle_vip_shop_menu");
    
    // CVars
    cvar_vip_enabled = register_cvar("zp_vip_enabled", "1");
    cvar_vip_xp_bonus = register_cvar("zp_vip_xp_bonus_mult", "1.5"); // 1.5x
    cvar_vip_credits_bonus = register_cvar("zp_vip_credits_bonus_mult", "1.5");
    
    // Periodic tasks
    set_task(1.0, "task_vip_check", 0, "", 0, "b"); // Check VIP expiration
    
    server_print("[ZP] VIP System initialized!");
}

// ==================== EVENTS ====================

public logevent_player_connect() {
    new player_id = read_logdata(1);
    
    if(!is_user_connected(player_id))
        return;
    
    // Load VIP data (from database)
    load_vip_data(player_id);
}

public event_round_start() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_connected(id) && g_player_vip_tier[id] > VIP_NONE) {
            client_print(id, print_center, "VIP %d: Enjoy your benefits!", g_player_vip_tier[id]);
        }
    }
}

// ==================== VIP COMMANDS ====================

public cmd_show_vip_info(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new vip_tier = g_player_vip_tier[id];
    
    if(vip_tier == VIP_NONE) {
        client_print(id, print_chat, "[ZP] You are not VIP. Use /buyvip to become VIP!");
    } else {
        new vip_name[32];
        copy(vip_name, 31, g_vip_tiers[vip_tier - 1][VT_NAME]);
        
        new expire_time = g_player_vip_expire[id];
        new current_time = get_systime();
        new days_left = (expire_time - current_time) / 86400;
        
        client_print(id, print_chat, "[ZP] Current VIP: %s", vip_name);
        client_print(id, print_chat, "[ZP] Days remaining: %d", days_left);
        
        show_vip_benefits(id, vip_tier);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_buyvip(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_vip_shop(id);
    
    return PLUGIN_HANDLED;
}

public cmd_vip_shop(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_vip_shop(id);
    
    return PLUGIN_HANDLED;
}

public show_vip_shop(id) {
    new menu[512];
    new len = 0;
    
    len += format(menu[len], 511 - len, "\y[ZP] VIP Shop\w\n\n");
    len += format(menu[len], 511 - len, "Your Credits: $\y%d\w\n\n", get_player_credits(id));
    
    for(new i = 0; i < 5; i++) {
        new price = g_vip_tiers[i][VT_PRICE];
        new days = g_vip_tiers[i][VT_DURATION];
        len += format(menu[len], 511 - len, "%d. %s - $%d (%d days)\n",
            i + 1,
            g_vip_tiers[i][VT_NAME],
            price,
            days
        );
    }
    
    len += format(menu[len], 511 - len, "\n0. \rClose\n");
    
    show_menu(id, (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5), menu);
}

public handle_vip_shop_menu(id, key) {
    if(key < 0 || key >= 5)
        return;
    
    new vip_tier = key + 1;
    new price = g_vip_tiers[key][VT_PRICE];
    new days = g_vip_tiers[key][VT_DURATION];
    new vip_name[32];
    copy(vip_name, 31, g_vip_tiers[key][VT_NAME]);
    
    // Check if player has enough credits
    if(get_player_credits(id) < price) {
        client_print(id, print_chat, "[ZP] Not enough credits! (Need: $%d)", price);
        return;
    }
    
    // Purchase VIP
    remove_player_credits(id, price);
    set_player_vip(id, vip_tier, days);
    
    client_print(id, print_chat, "[ZP] Welcome to %s! ($%d)", vip_name, price);
    client_print(0, print_center, "%N is now %s!", id, vip_name);
    
    save_vip_data(id);
}

public cmd_vip_status(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new vip_tier = g_player_vip_tier[id];
    
    if(vip_tier == VIP_NONE) {
        client_print(id, print_chat, "[ZP] Status: Not VIP");
    } else {
        new vip_name[32];
        copy(vip_name, 31, g_vip_tiers[vip_tier - 1][VT_NAME]);
        
        new expire_time = g_player_vip_expire[id];
        new current_time = get_systime();
        new time_left = expire_time - current_time;
        new days = time_left / 86400;
        new hours = (time_left % 86400) / 3600;
        
        client_print(id, print_chat, "[ZP] Status: %s", vip_name);
        client_print(id, print_chat, "[ZP] Expires: %dd %dh", days, hours);
    }
    
    return PLUGIN_HANDLED;
}

public cmd_vip_list(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    client_print(id, print_chat, "========== VIP PLAYERS ==========");
    
    new vip_count = 0;
    for(new i = 0; i < count; i++) {
        new pid = players[i];
        new vip_tier = g_player_vip_tier[pid];
        
        if(vip_tier > VIP_NONE) {
            new pname[32];
            new vip_name[32];
            get_user_name(pid, pname, 31);
            copy(vip_name, 31, g_vip_tiers[vip_tier - 1][VT_NAME]);
            
            client_print(id, print_chat, "%s - %s", pname, vip_name);
            vip_count++;
        }
    }
    
    if(vip_count == 0)
        client_print(id, print_chat, "No VIP players online");
    
    client_print(id, print_chat, "================================");
    
    return PLUGIN_HANDLED;
}

// ==================== VIP FUNCTIONS ====================

public load_vip_data(id) {
    // Load from database (simplified)
    g_player_vip_tier[id] = VIP_NONE;
    g_player_vip_expire[id] = 0;
}

public save_vip_data(id) {
    // Save to database (simplified)
}

public set_player_vip(id, tier, days) {
    if(!is_user_connected(id) || tier < 0 || tier > 5)
        return;
    
    g_player_vip_tier[id] = tier;
    g_player_vip_expire[id] = get_systime() + (days * 86400);
}

public get_player_vip_tier(id) {
    if(!is_user_connected(id))
        return VIP_NONE;
    return g_player_vip_tier[id];
}

public get_vip_xp_bonus(id) {
    new vip_tier = g_player_vip_tier[id];
    if(vip_tier == VIP_NONE)
        return 100; // No bonus
    
    return 100 + g_vip_tiers[vip_tier - 1][VT_XP_BONUS];
}

public get_vip_credits_bonus(id) {
    new vip_tier = g_player_vip_tier[id];
    if(vip_tier == VIP_NONE)
        return 100; // No bonus
    
    return 100 + g_vip_tiers[vip_tier - 1][VT_CREDITS_BONUS];
}

public get_vip_hp_bonus(id) {
    new vip_tier = g_player_vip_tier[id];
    if(vip_tier == VIP_NONE)
        return 0;
    
    return g_vip_tiers[vip_tier - 1][VT_HP_BONUS];
}

public get_vip_speed_bonus(id) {
    new vip_tier = g_player_vip_tier[id];
    if(vip_tier == VIP_NONE)
        return 0;
    
    return g_vip_tiers[vip_tier - 1][VT_SPEED_BONUS];
}

// ==================== VIP CHECK ====================

public task_vip_check() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    new current_time = get_systime();
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(!is_user_connected(id))
            continue;
        
        if(g_player_vip_tier[id] > VIP_NONE) {
            // Check if VIP expired
            if(g_player_vip_expire[id] <= current_time) {
                client_print(id, print_chat, "[ZP] Your VIP subscription has expired!");
                g_player_vip_tier[id] = VIP_NONE;
                g_player_vip_expire[id] = 0;
            }
        }
    }
}

// ==================== BENEFITS DISPLAY ====================

public show_vip_benefits(id, tier) {
    if(tier < 1 || tier > 5)
        return;
    
    new idx = tier - 1;
    
    client_print(id, print_chat, "[ZP] VIP Benefits:");
    client_print(id, print_chat, "[ZP] XP Bonus: +%d%%", g_vip_tiers[idx][VT_XP_BONUS]);
    client_print(id, print_chat, "[ZP] Credits Bonus: +%d%%", g_vip_tiers[idx][VT_CREDITS_BONUS]);
    client_print(id, print_chat, "[ZP] HP Bonus: +%d", g_vip_tiers[idx][VT_HP_BONUS]);
    client_print(id, print_chat, "[ZP] Speed Bonus: +%d", g_vip_tiers[idx][VT_SPEED_BONUS]);
}

// ==================== NATIVES ====================

native get_player_credits(id);
native remove_player_credits(id, amount);

// End of file
