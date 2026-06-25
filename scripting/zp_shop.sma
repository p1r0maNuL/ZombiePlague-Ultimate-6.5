/*
 * Zombie Plague Ultimate 6.5 - Shop System
 * 
 * File: zp_shop.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Shop interface and menu system
 * - Item buying/selling
 * - Weapon shop
 * - Ammo shop
 * - Utility items shop
 * - Daily bonuses
 * - Slot machine
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include "include/zombie_plague.inc"

// ==================== SHOP ITEM DEFINITIONS ====================

enum ShopItem {
    SI_ID,
    SI_NAME[32],
    SI_DESCRIPTION[64],
    SI_PRICE,
    SI_CATEGORY,
    SI_WEAPON_NAME[32],
    SI_MAX_COUNT
};

#define SHOP_CATEGORY_WEAPON 0
#define SHOP_CATEGORY_UTILITY 1
#define SHOP_CATEGORY_AMMO 2
#define SHOP_CATEGORY_SPECIAL 3

// Shop items (20 items)
static g_shop_items[][ShopItem] = {
    // Weapons
    {0, "M4A1", "Standard rifle", 0, SHOP_CATEGORY_WEAPON, "weapon_m4a1", 1},
    {1, "AWP Dragon Lore", "Sniper rifle", 5000, SHOP_CATEGORY_WEAPON, "weapon_awp", 1},
    {2, "Deagle", "Pistol", 800, SHOP_CATEGORY_WEAPON, "weapon_deagle", 1},
    {3, "Shotgun", "XM1014", 1200, SHOP_CATEGORY_WEAPON, "weapon_xm1014", 1},
    {4, "M249", "LMG", 4000, SHOP_CATEGORY_WEAPON, "weapon_m249", 1},
    
    // Utility
    {5, "Kevlar Armor", "+25 Armor", 650, SHOP_CATEGORY_UTILITY, "", 1},
    {6, "Health Pack", "+100 HP", 500, SHOP_CATEGORY_UTILITY, "", 3},
    {7, "Flashbang", "Stun enemies", 200, SHOP_CATEGORY_UTILITY, "weapon_flashbang", 2},
    {8, "Smoke Grenade", "Cover movement", 300, SHOP_CATEGORY_UTILITY, "weapon_smokegrenade", 2},
    {9, "HE Grenade", "Explosive", 400, SHOP_CATEGORY_UTILITY, "weapon_hegrenade", 2},
    
    // Ammo
    {10, "Ammo Pack (556)", "200 bullets", 100, SHOP_CATEGORY_AMMO, "", 5},
    {11, "Ammo Pack (9mm)", "100 bullets", 80, SHOP_CATEGORY_AMMO, "", 5},
    {12, "Ammo Pack (762)", "100 bullets", 120, SHOP_CATEGORY_AMMO, "", 3},
    {13, "Ammo Pack (338)", "30 bullets", 150, SHOP_CATEGORY_AMMO, "", 2},
    
    // Special
    {14, "Experience Boost", "+50% XP (1 round)", 2000, SHOP_CATEGORY_SPECIAL, "", 1},
    {15, "Credits Boost", "+50% Credits (1 round)", 1500, SHOP_CATEGORY_SPECIAL, "", 1},
    {16, "Speed Boost", "+20% Speed (1 round)", 1000, SHOP_CATEGORY_SPECIAL, "", 1},
    {17, "Damage Boost", "+30% Damage (1 round)", 1200, SHOP_CATEGORY_SPECIAL, "", 1},
    {18, "Invincibility (10s)", "Be unkillable", 5000, SHOP_CATEGORY_SPECIAL, "", 1},
    {19, "Teleport", "Teleport to random location", 3000, SHOP_CATEGORY_SPECIAL, "", 2}
};

#define TOTAL_SHOP_ITEMS 20

// ==================== GLOBALS ====================

new g_player_shop_menu[MAX_PLAYERS + 1];
new g_player_last_daily_bonus[MAX_PLAYERS + 1];

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Shop System", "6.5", "p1r0maNuL");
    
    // Register commands
    register_concmd("say /shop", "cmd_open_shop");
    register_concmd("say /buy", "cmd_open_shop");
    register_concmd("say /items", "cmd_open_shop");
    register_concmd("say /daily", "cmd_daily_bonus");
    register_concmd("say /slot", "cmd_slot_machine");
    
    // Register menu handlers
    register_menucmd(register_menuid("Shop Menu"), (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), "handle_shop_menu");
    
    server_print("[ZP] Shop System initialized!");
}

// ==================== SHOP MENU ====================

public cmd_open_shop(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_shop_menu(id);
    
    return PLUGIN_HANDLED;
}

public show_shop_menu(id) {
    new menu[512];
    new len = 0;
    
    len += format(menu[len], 511 - len, "\y[ZP] Shop Menu\w\n\n");
    len += format(menu[len], 511 - len, "Your Credits: $\y%d\w\n\n", get_player_credits(id));
    
    len += format(menu[len], 511 - len, "\n\w1. \yWeapons\n");
    len += format(menu[len], 511 - len, "2. \yUtility Items\n");
    len += format(menu[len], 511 - len, "3. \yAmmo Packs\n");
    len += format(menu[len], 511 - len, "4. \ySpecial Items\n");
    len += format(menu[len], 511 - len, "5. \yDaily Bonus\n");
    len += format(menu[len], 511 - len, "6. \ySlot Machine\n");
    len += format(menu[len], 511 - len, "\n0. \rClose\n");
    
    show_menu(id, (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5), menu);
}

public handle_shop_menu(id, key) {
    switch(key) {
        case 0: show_category_menu(id, SHOP_CATEGORY_WEAPON); // Weapons
        case 1: show_category_menu(id, SHOP_CATEGORY_UTILITY); // Utility
        case 2: show_category_menu(id, SHOP_CATEGORY_AMMO); // Ammo
        case 3: show_category_menu(id, SHOP_CATEGORY_SPECIAL); // Special
        case 4: cmd_daily_bonus(id, 0, 0); // Daily bonus
        case 5: cmd_slot_machine(id, 0, 0); // Slot machine
        case 9: show_shop_menu(id); // Back
    }
}

public show_category_menu(id, category) {
    new menu[1024];
    new len = 0;
    new item_count = 0;
    new category_name[32];
    
    switch(category) {
        case SHOP_CATEGORY_WEAPON: copy(category_name, 31, "Weapons");
        case SHOP_CATEGORY_UTILITY: copy(category_name, 31, "Utility");
        case SHOP_CATEGORY_AMMO: copy(category_name, 31, "Ammo");
        case SHOP_CATEGORY_SPECIAL: copy(category_name, 31, "Special");
    }
    
    len += format(menu[len], 1023 - len, "\y[ZP] %s\w\n\n", category_name);
    len += format(menu[len], 1023 - len, "Your Credits: $\y%d\w\n\n", get_player_credits(id));
    
    for(new i = 0; i < TOTAL_SHOP_ITEMS; i++) {
        if(g_shop_items[i][SI_CATEGORY] == category && item_count < 8) {
            len += format(menu[len], 1023 - len, "%d. \y%s \w- $%d\n",
                item_count + 1,
                g_shop_items[i][SI_NAME],
                g_shop_items[i][SI_PRICE]
            );
            item_count++;
        }
    }
    
    len += format(menu[len], 1023 - len, "\n9. \rBack\n0. \rClose\n");
    
    show_menu(id, (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), menu);
}

// ==================== DAILY BONUS ====================

public cmd_daily_bonus(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new current_time = get_systime();
    new last_bonus = g_player_last_daily_bonus[id];
    new time_diff = current_time - last_bonus;
    
    if(time_diff < 86400) { // 24 hours
        new hours_left = (86400 - time_diff) / 3600;
        client_print(id, print_chat, "[ZP] Daily bonus available in %d hours!", hours_left);
        return PLUGIN_HANDLED;
    }
    
    // Award daily bonus
    new bonus_amount = 500;
    add_player_credits(id, bonus_amount);
    
    g_player_last_daily_bonus[id] = current_time;
    
    client_print(id, print_chat, "[ZP] Daily Bonus: +$%d!", bonus_amount);
    client_print(0, print_center, "%N claimed daily bonus!", id);
    
    return PLUGIN_HANDLED;
}

// ==================== SLOT MACHINE ====================

public cmd_slot_machine(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new cost = 100;
    
    if(get_player_credits(id) < cost) {
        client_print(id, print_chat, "[ZP] Not enough credits! (Cost: $%d)", cost);
        return PLUGIN_HANDLED;
    }
    
    // Remove credits
    remove_player_credits(id, cost);
    
    // Spin the slot machine
    new result = random(100);
    new win_amount = 0;
    
    if(result < 50) {
        // Loss (50%)
        client_print(id, print_chat, "[ZP] Slot Machine: Lost!");
        client_print(id, print_chat, "[ZP] -$%d", cost);
    } else if(result < 80) {
        // Small win (30%)
        win_amount = 250;
        add_player_credits(id, win_amount);
        client_print(id, print_chat, "[ZP] Slot Machine: Small Win! +$%d", win_amount);
    } else if(result < 95) {
        // Medium win (15%)
        win_amount = 500;
        add_player_credits(id, win_amount);
        client_print(id, print_chat, "[ZP] Slot Machine: Medium Win! +$%d", win_amount);
    } else {
        // Jackpot (5%)
        win_amount = 2000;
        add_player_credits(id, win_amount);
        client_print(0, print_center, "%N won the JACKPOT! +$%d", id, win_amount);
    }
    
    return PLUGIN_HANDLED;
}

// ==================== NATIVES ====================

native get_player_credits(id);
native add_player_credits(id, amount);
native remove_player_credits(id, amount);

// End of file
