/*
 * Zombie Plague Ultimate 6.5 - Main Plugin
 * 
 * File: zp_main.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This is the main entry point for the Zombie Plague Ultimate plugin.
 * It initializes all subsystems and manages the core game loop.
 */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include "include/zombie_plague.inc"
#include "include/zp_gamemodes.inc"
#include "include/zp_classes.inc"
#include "include/zp_vip.inc"

// Plugin info
new const PLUGIN_NAME[] = "Zombie Plague Ultimate 6.5";
new const PLUGIN_VERSION[] = "6.5.0";
new const PLUGIN_AUTHOR[] = "p1r0maNuL";

// Plugin description
public plugin_init() {
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
    register_cvar("zp_version", PLUGIN_VERSION, FCVAR_SERVER);
    
    // Register commands
    register_concmd("say /zp", "cmd_zp_menu");
    register_concmd("say /info", "cmd_info");
    register_concmd("say /credits", "cmd_show_credits");
    register_concmd("say /level", "cmd_show_level");
    register_concmd("say /class", "cmd_show_class");
    register_concmd("say /vip", "cmd_vip_info");
    register_concmd("say /shop", "cmd_shop");
    register_concmd("say /register", "cmd_register");
    register_concmd("say /login", "cmd_login");
    
    server_print("[ZP] Zombie Plague Ultimate 6.5 - Loaded!");
}

public plugin_precache() {
    server_print("[ZP] Precaching resources...");
}

// Command: Main menu
public cmd_zp_menu(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Welcome to Zombie Plague Ultimate 6.5");
    client_print(id, print_chat, "[ZP] Use /info, /credits, /level, /class, /vip, /shop");
    
    return PLUGIN_HANDLED;
}

public cmd_info(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "%s v%s", PLUGIN_NAME, PLUGIN_VERSION);
    client_print(id, print_chat, "Advanced Zombie Mode Plugin for CS 1.6");
    client_print(id, print_chat, "Created by %s", PLUGIN_AUTHOR);
    
    return PLUGIN_HANDLED;
}

public cmd_show_credits(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Credits System Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_show_level(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Level System Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_show_class(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Class System Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_vip_info(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] VIP System Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_shop(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Shop System Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_register(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Registration Coming Soon");
    
    return PLUGIN_HANDLED;
}

public cmd_login(id, level, cid) {
    if(!cmd_access(id, level, cid, 1))
        return PLUGIN_HANDLED;
    
    client_print(id, print_chat, "[ZP] Login System Coming Soon");
    
    return PLUGIN_HANDLED;
}

// End of file
