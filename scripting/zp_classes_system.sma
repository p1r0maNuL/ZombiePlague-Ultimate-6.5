/*
 * Zombie Plague Ultimate 6.5 - Classes System
 * 
 * File: zp_classes_system.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Class selection and unlocking
 * - Class abilities
 * - Class stats management
 * - Class progression system
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include "include/zombie_plague.inc"
#include "include/zp_classes.inc"

// ==================== GLOBALS ====================

// Player selected classes
new g_player_zombie_class[MAX_PLAYERS + 1];
new g_player_human_class[MAX_PLAYERS + 1];
new g_player_class_unlocked[MAX_PLAYERS + 1][MAX_CLASSES];

// Class stats cache
enum ClassStats {
    CS_NAME[32],
    CS_HP,
    CS_SPEED,
    CS_ARMOR,
    CS_PRICE,
    CS_LEVEL_REQUIRED
};

new g_zombie_classes[24][ClassStats];
new g_human_classes[24][ClassStats];

// ==================== PLUGIN INIT ====================

public plugin_init() {
    register_plugin("Zombie Plague - Classes System", "6.5", "p1r0maNuL");
    
    // Register commands
    register_concmd("say /zclass", "cmd_select_zombie_class");
    register_concmd("say /hclass", "cmd_select_human_class");
    register_concmd("say /classes", "cmd_show_classes");
    register_concmd("say /unlock", "cmd_unlock_class");
    
    // Register menu handlers
    register_menucmd(register_menuid("Zombie Class Menu"), (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), "handle_zombie_class_menu");
    register_menucmd(register_menuid("Human Class Menu"), (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), "handle_human_class_menu");
    
    // Initialize class data
    init_class_data();
    
    server_print("[ZP] Classes System initialized!");
}

// ==================== CLASS DATA INITIALIZATION ====================

public init_class_data() {
    // Zombie Classes (24 total)
    copy(g_zombie_classes[0][CS_NAME], 31, "Regenerator");
    g_zombie_classes[0][CS_HP] = 4000;
    g_zombie_classes[0][CS_SPEED] = 280;
    g_zombie_classes[0][CS_ARMOR] = 0;
    g_zombie_classes[0][CS_PRICE] = 0;
    g_zombie_classes[0][CS_LEVEL_REQUIRED] = 1;
    
    copy(g_zombie_classes[1][CS_NAME], 31, "WallBanger");
    g_zombie_classes[1][CS_HP] = 4500;
    g_zombie_classes[1][CS_SPEED] = 300;
    g_zombie_classes[1][CS_ARMOR] = 0;
    g_zombie_classes[1][CS_PRICE] = 1000;
    g_zombie_classes[1][CS_LEVEL_REQUIRED] = 5;
    
    copy(g_zombie_classes[2][CS_NAME], 31, "Copycat");
    g_zombie_classes[2][CS_HP] = 6000;
    g_zombie_classes[2][CS_SPEED] = 340;
    g_zombie_classes[2][CS_ARMOR] = 0;
    g_zombie_classes[2][CS_PRICE] = 2000;
    g_zombie_classes[2][CS_LEVEL_REQUIRED] = 9;
    
    copy(g_zombie_classes[3][CS_NAME], 31, "Miss Doctor");
    g_zombie_classes[3][CS_HP] = 7500;
    g_zombie_classes[3][CS_SPEED] = 360;
    g_zombie_classes[3][CS_ARMOR] = 0;
    g_zombie_classes[3][CS_PRICE] = 3000;
    g_zombie_classes[3][CS_LEVEL_REQUIRED] = 13;
    
    copy(g_zombie_classes[4][CS_NAME], 31, "The Stinger");
    g_zombie_classes[4][CS_HP] = 8500;
    g_zombie_classes[4][CS_SPEED] = 390;
    g_zombie_classes[4][CS_ARMOR] = 0;
    g_zombie_classes[4][CS_PRICE] = 5000;
    g_zombie_classes[4][CS_LEVEL_REQUIRED] = 17;
    
    // Continue for all 24 zombie classes (abbreviated for space)
    init_remaining_zombie_classes();
    
    // Human Classes (24 total)
    copy(g_human_classes[0][CS_NAME], 31, "Ryner");
    g_human_classes[0][CS_HP] = 120;
    g_human_classes[0][CS_SPEED] = 280;
    g_human_classes[0][CS_ARMOR] = 0;
    g_human_classes[0][CS_PRICE] = 0;
    g_human_classes[0][CS_LEVEL_REQUIRED] = 1;
    
    copy(g_human_classes[1][CS_NAME], 31, "Yuanshu");
    g_human_classes[1][CS_HP] = 130;
    g_human_classes[1][CS_SPEED] = 300;
    g_human_classes[1][CS_ARMOR] = 10;
    g_human_classes[1][CS_PRICE] = 1000;
    g_human_classes[1][CS_LEVEL_REQUIRED] = 5;
    
    copy(g_human_classes[2][CS_NAME], 31, "Faurel");
    g_human_classes[2][CS_HP] = 145;
    g_human_classes[2][CS_SPEED] = 340;
    g_human_classes[2][CS_ARMOR] = 15;
    g_human_classes[2][CS_PRICE] = 2000;
    g_human_classes[2][CS_LEVEL_REQUIRED] = 9;
    
    // Continue for all 24 human classes
    init_remaining_human_classes();
}

public init_remaining_zombie_classes() {
    // Classes 5-23 initialization (abbreviated)
    for(new i = 5; i < 24; i++) {
        format(g_zombie_classes[i][CS_NAME], 31, "Zombie Class %d", i + 1);
        g_zombie_classes[i][CS_HP] = 4000 + (i * 200);
        g_zombie_classes[i][CS_SPEED] = 280 + (i * 10);
        g_zombie_classes[i][CS_ARMOR] = 0;
        g_zombie_classes[i][CS_PRICE] = i * 1000;
        g_zombie_classes[i][CS_LEVEL_REQUIRED] = 1 + (i * 4);
    }
}

public init_remaining_human_classes() {
    // Classes 3-23 initialization (abbreviated)
    for(new i = 3; i < 24; i++) {
        format(g_human_classes[i][CS_NAME], 31, "Human Class %d", i + 1);
        g_human_classes[i][CS_HP] = 120 + (i * 20);
        g_human_classes[i][CS_SPEED] = 280 + (i * 10);
        g_human_classes[i][CS_ARMOR] = i * 5;
        g_human_classes[i][CS_PRICE] = i * 1000;
        g_human_classes[i][CS_LEVEL_REQUIRED] = 1 + (i * 4);
    }
}

// ==================== CLASS SELECTION COMMANDS ====================

public cmd_select_zombie_class(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_zombie_class_menu(id);
    
    return PLUGIN_HANDLED;
}

public cmd_select_human_class(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    show_human_class_menu(id);
    
    return PLUGIN_HANDLED;
}

public show_zombie_class_menu(id) {
    new menu[1024];
    new len = 0;
    
    len += format(menu[len], 1023 - len, "\y[ZP] Zombie Classes\w\n\n");
    
    for(new i = 0; i < 8 && i < 24; i++) {
        new status[32];
        
        if(g_player_class_unlocked[id][i])
            copy(status, 31, "\y[UNLOCKED]");
        else
            format(status, 31, "\r[LOCK] $%d", g_zombie_classes[i][CS_PRICE]);
        
        len += format(menu[len], 1023 - len, "%d. %s %s\n",
            i + 1,
            g_zombie_classes[i][CS_NAME],
            status
        );
    }
    
    len += format(menu[len], 1023 - len, "\n9. \rBack\n0. \rClose\n");
    
    show_menu(id, (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), menu);
}

public show_human_class_menu(id) {
    new menu[1024];
    new len = 0;
    
    len += format(menu[len], 1023 - len, "\y[ZP] Human Classes\w\n\n");
    
    for(new i = 0; i < 8 && i < 24; i++) {
        new status[32];
        
        if(g_player_class_unlocked[id][i + 24])
            copy(status, 31, "\y[UNLOCKED]");
        else
            format(status, 31, "\r[LOCK] $%d", g_human_classes[i][CS_PRICE]);
        
        len += format(menu[len], 1023 - len, "%d. %s %s\n",
            i + 1,
            g_human_classes[i][CS_NAME],
            status
        );
    }
    
    len += format(menu[len], 1023 - len, "\n9. \rBack\n0. \rClose\n");
    
    show_menu(id, (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9), menu);
}

public handle_zombie_class_menu(id, key) {
    if(key == 9) return; // Back/Close
    if(key < 0 || key >= 8) return;
    
    // Select zombie class
    g_player_zombie_class[id] = key;
    client_print(id, print_chat, "[ZP] Selected zombie class: %s", g_zombie_classes[key][CS_NAME]);
}

public handle_human_class_menu(id, key) {
    if(key == 9) return; // Back/Close
    if(key < 0 || key >= 8) return;
    
    // Select human class
    g_player_human_class[id] = key;
    client_print(id, print_chat, "[ZP] Selected human class: %s", g_human_classes[key][CS_NAME]);
}

// ==================== UNLOCK CLASS ====================

public cmd_unlock_class(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new args[32];
    read_args(args, 31);
    trim(args);
    
    if(!args[0]) {
        client_print(id, print_chat, "[ZP] Usage: /unlock <class_id>");
        return PLUGIN_HANDLED;
    }
    
    new class_id = str_to_num(args);
    
    if(class_id < 0 || class_id >= 48) {
        client_print(id, print_chat, "[ZP] Invalid class ID!");
        return PLUGIN_HANDLED;
    }
    
    if(g_player_class_unlocked[id][class_id]) {
        client_print(id, print_chat, "[ZP] You already have this class!");
        return PLUGIN_HANDLED;
    }
    
    // Determine if zombie or human class
    new is_zombie = (class_id < 24);
    new class_idx = is_zombie ? class_id : (class_id - 24);
    new cost = is_zombie ? g_zombie_classes[class_idx][CS_PRICE] : g_human_classes[class_idx][CS_PRICE];
    
    // Check if player has enough credits
    if(get_player_credits(id) < cost) {
        client_print(id, print_chat, "[ZP] Not enough credits! (Need: $%d)", cost);
        return PLUGIN_HANDLED;
    }
    
    // Unlock class
    remove_player_credits(id, cost);
    g_player_class_unlocked[id][class_id] = 1;
    
    new class_name[32];
    copy(class_name, 31, is_zombie ? g_zombie_classes[class_idx][CS_NAME] : g_human_classes[class_idx][CS_NAME]);
    
    client_print(id, print_chat, "[ZP] Unlocked: %s (-$%d)", class_name, cost);
    client_print(0, print_center, "%N unlocked class: %s!", id, class_name);
    
    return PLUGIN_HANDLED;
}

// ==================== SHOW CLASSES INFO ====================

public cmd_show_classes(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    new current_z_class = g_player_zombie_class[id];
    new current_h_class = g_player_human_class[id];
    
    client_print(id, print_chat, "========== YOUR CLASSES ==========");
    client_print(id, print_chat, "Zombie: %s (HP: %d, Speed: %d)",
        g_zombie_classes[current_z_class][CS_NAME],
        g_zombie_classes[current_z_class][CS_HP],
        g_zombie_classes[current_z_class][CS_SPEED]
    );
    client_print(id, print_chat, "Human: %s (HP: %d, Speed: %d, Armor: %d)",
        g_human_classes[current_h_class][CS_NAME],
        g_human_classes[current_h_class][CS_HP],
        g_human_classes[current_h_class][CS_SPEED],
        g_human_classes[current_h_class][CS_ARMOR]
    );
    client_print(id, print_chat, "===================================");
    
    return PLUGIN_HANDLED;
}

// ==================== GETTERS ====================

public get_zombie_class_hp(class_id) {
    if(class_id < 0 || class_id >= 24)
        return 4000; // Default
    return g_zombie_classes[class_id][CS_HP];
}

public get_zombie_class_speed(class_id) {
    if(class_id < 0 || class_id >= 24)
        return 280; // Default
    return g_zombie_classes[class_id][CS_SPEED];
}

public get_human_class_hp(class_id) {
    if(class_id < 0 || class_id >= 24)
        return 120; // Default
    return g_human_classes[class_id][CS_HP];
}

public get_human_class_speed(class_id) {
    if(class_id < 0 || class_id >= 24)
        return 280; // Default
    return g_human_classes[class_id][CS_SPEED];
}

public get_human_class_armor(class_id) {
    if(class_id < 0 || class_id >= 24)
        return 0; // Default
    return g_human_classes[class_id][CS_ARMOR];
}

// ==================== NATIVES ====================

native get_player_credits(id);
native remove_player_credits(id, amount);

// End of file
