/*
 * Zombie Plague Ultimate 6.5 - Special Event Modes
 * 
 * File: zp_special_events.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Holiday-specific game modes
 * - Limited-time challenges
 * - Event-based zombie types
 * - Seasonal modifiers
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>

// ==================== SPECIAL ZOMBIE TYPES ====================

public halloween_pumpkin_zombie(id) {
    // Halloween special: Pumpkin Zombie
    set_user_health(id, 5000);
    set_user_speed(id, 280);
    client_print(id, print_chat, "[ZP] You are a Halloween Pumpkin Zombie!");
}

public christmas_frost_zombie(id) {
    // Christmas special: Frost Zombie
    set_user_health(id, 4500);
    set_user_speed(id, 250); // Slower but more durable
    client_print(id, print_chat, "[ZP] You are a Christmas Frost Zombie!");
}

public summer_magma_zombie(id) {
    // Summer special: Magma Zombie
    set_user_health(id, 3500);
    set_user_speed(id, 350); // Faster and weaker
    client_print(id, print_chat, "[ZP] You are a Summer Magma Zombie!");
}

// ==================== HALLOWEEN MODE ====================

public halloween_speedrun_challenge() {
    // Beat round in 60 seconds for bonus rewards
    client_print(0, print_center, "HALLOWEEN: 60 Second Speedrun Challenge!");
    client_print(0, print_chat, "[ZP] Survive 60 seconds for triple rewards!");
    
    set_task(60.0, "halloween_speedrun_end");
}

public halloween_speedrun_end() {
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    // Award survivors
    for(new i = 0; i < count; i++) {
        new id = players[i];
        if(is_user_alive(id) && !is_user_zombie(id)) {
            add_player_credits(id, 1000);
            add_player_xp(id, 500);
        }
    }
    
    client_print(0, print_center, "CHALLENGE COMPLETED!");
}

// ==================== CHRISTMAS MODE ====================

public christmas_gift_drop() {
    // Christmas special: Random gifts appear
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        
        if(random(100) < 30) { // 30% chance
            new gift_type = random(3);
            
            switch(gift_type) {
                case 0: { // Health
                    set_user_health(id, min(100, get_user_health(id) + 50));
                    client_print(id, print_chat, "[ZP] Gift: +50 Health");
                }
                case 1: { // Credits
                    add_player_credits(id, 500);
                    client_print(id, print_chat, "[ZP] Gift: +500 Credits");
                }
                case 2: { // XP
                    add_player_xp(id, 250);
                    client_print(id, print_chat, "[ZP] Gift: +250 XP");
                }
            }
        }
    }
    
    set_task(30.0, "christmas_gift_drop");
}

// ==================== EASTER EGG HUNT ====================

public easter_egg_hunt() {
    client_print(0, print_center, "EASTER: Egg Hunt Challenge!");
    client_print(0, print_chat, "[ZP] Find 5 hidden eggs for reward!");
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        client_print(id, print_chat, "[ZP] Look for glowing eggs on the map!");
    }
}

public easter_collect_egg(id) {
    new collected = get_player_var(id, "easter_eggs");
    collected++;
    set_player_var(id, "easter_eggs", collected);
    
    if(collected >= 5) {
        // Award reward
        add_player_credits(id, 2000);
        add_player_xp(id, 1000);
        client_print(id, print_center, "EASTER: All eggs collected!");
        client_print(id, print_chat, "[ZP] Reward: +2000 Credits, +1000 XP");
    }
}

// ==================== NEW YEAR EVENT ====================

public new_year_reset_challenge() {
    // New Year: Fresh start bonuses
    client_print(0, print_center, "HAPPY NEW YEAR!");
    client_print(0, print_chat, "[ZP] All players get +1000 credits bonus!");
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        add_player_credits(id, 1000);
    }
}

// ==================== ANNIVERSARY BASH ====================

public anniversary_bash_event() {
    // Server anniversary: Jackpot mode
    client_print(0, print_center, "🎉 ANNIVERSARY BASH 🎉");
    client_print(0, print_chat, "[ZP] Double rewards all day!");
    client_print(0, print_chat, "[ZP] Lucky players get random bonuses!");
    
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new id = players[i];
        
        // Everyone gets base bonus
        add_player_credits(id, 500);
        add_player_xp(id, 250);
        
        // 10% chance for jackpot
        if(random(100) < 10) {
            add_player_credits(id, 5000);
            client_print(0, print_center, "%N won JACKPOT! +5000 Credits!", id);
        }
    }
}

// ==================== UTILITIES ====================

static min(a, b) {
    return (a < b) ? a : b;
}

// ==================== NATIVES ====================

native add_player_xp(id, amount);
native add_player_credits(id, amount);
native is_user_zombie(id);
native set_user_health(id, health);
native get_user_health(id);
native get_player_var(id, var_name[]);
native set_player_var(id, var_name[], value);

// End of file
