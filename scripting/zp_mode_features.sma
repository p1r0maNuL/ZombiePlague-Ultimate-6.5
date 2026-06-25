/*
 * Zombie Plague Ultimate 6.5 - Mode-Specific Features
 * 
 * File: zp_mode_features.sma
 * Version: 6.5
 * Author: p1r0maNuL
 * 
 * This file handles:
 * - Nemesis special abilities
 * - Plague zombie features
 * - Swarm wave progression
 * - Infection mechanics
 */

#include <amxmodx>
#include <amxmisc>
#include <fun>

// ==================== NEMESIS ABILITIES ====================

public nemesis_special_attack(id) {
    if(!is_user_nemesis(id))
        return;
    
    // Nemesis dash ability (2x speed for 5 seconds)
    set_user_speed(id, 800);
    client_print(id, print_chat, "[ZP] Nemesis dash activated!");
    
    set_task(5.0, "reset_nemesis_speed", id);
}

public reset_nemesis_speed(id) {
    if(is_user_connected(id)) {
        set_user_speed(id, 400);
    }
}

public nemesis_ground_stomp(id) {
    if(!is_user_nemesis(id))
        return;
    
    // Ground stomp: damage nearby humans
    new players[MAX_PLAYERS], count = 0;
    get_players(players, count, "a");
    
    for(new i = 0; i < count; i++) {
        new target = players[i];
        
        if(target == id || !is_user_alive(target))
            continue;
        
        new dist = get_distance(id, target);
        
        if(dist <= 500) {
            // Deal 50 damage
            user_take_damage(target, 50);
        }
    }
    
    client_print(id, print_chat, "[ZP] Nemesis stomp!");
}

// ==================== PLAGUE ZOMBIE FEATURES ====================

public plague_infection_spread(id, victim) {
    if(!is_user_plague(id))
        return;
    
    // Plague spreads faster (150% speed)
    new infection_chance = 150;
    
    if(random(100) < infection_chance) {
        // Infect victim
        set_user_zombie(victim, 1);
        set_user_plague(victim, 1);
        
        client_print(victim, print_chat, "[ZP] You have been infected by Plague!");
    }
}

public plague_regeneration(id) {
    if(!is_user_plague(id))
        return;
    
    // Plague zombies regenerate slowly (10 HP per second)
    new current_hp = get_user_health(id);
    new max_hp = get_zombie_class_hp(get_user_class(id));
    
    if(current_hp < max_hp) {
        set_user_health(id, min(current_hp + 10, max_hp));
    }
}

// ==================== SWARM WAVE SYSTEM ====================

public swarm_wave_progression(wave) {
    new zombie_count = 5 + (wave * 2);
    new zombie_hp_bonus = wave * 200;
    new zombie_speed_bonus = wave * 20;
    
    client_print(0, print_center, "Wave %d", wave);
    client_print(0, print_chat, "[ZP] Zombies: +%d HP, +%d Speed", zombie_hp_bonus, zombie_speed_bonus);
}

public swarm_spawn_wave_zombie(id, wave) {
    // Apply wave bonuses
    new bonus_hp = wave * 200;
    new bonus_speed = wave * 20;
    
    new base_hp = get_zombie_class_hp(get_user_class(id));
    set_user_health(id, base_hp + bonus_hp);
    set_user_speed(id, 300 + bonus_speed);
}

// ==================== INFECTION MECHANICS ====================

public handle_infection(attacker, victim) {
    // Check game mode
    new mode = get_current_game_mode();
    
    switch(mode) {
        case 1: { // Infection mode
            set_user_zombie(victim, 1);
            client_print(victim, print_chat, "[ZP] You have been infected!");
            client_print(0, print_center, "%N infected!", victim);
        }
        case 2: { // Survivor mode
            set_user_zombie(victim, 1);
            client_print(victim, print_chat, "[ZP] You have been infected!");
        }
        case 5: { // Plague mode
            plague_infection_spread(attacker, victim);
        }
    }
}

// ==================== UTILITIES ====================

static get_distance(id1, id2) {
    new pos1[3], pos2[3];
    get_user_origin(id1, pos1);
    get_user_origin(id2, pos2);
    
    new dx = pos2[0] - pos1[0];
    new dy = pos2[1] - pos1[1];
    new dz = pos2[2] - pos1[2];
    
    return floatround(sqrt(float(dx * dx + dy * dy + dz * dz)));
}

static min(a, b) {
    return (a < b) ? a : b;
}

// ==================== NATIVES ====================

native set_user_zombie(id, zombie);
native is_user_nemesis(id);
native is_user_plague(id);
native set_user_plague(id, plague);
native set_user_speed(id, speed);
native get_zombie_class_hp(class_id);
native get_user_class(id);
native get_current_game_mode();
native user_take_damage(id, amount);
native get_user_health(id);
native set_user_health(id, health);

// End of file
