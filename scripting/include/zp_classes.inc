/*
 * Zombie Plague Ultimate 6.5
 * Classes system definitions
 * 
 * File: zp_classes.inc
 * Version: 6.5
 */

#if defined _zp_classes_included
    #endinput
#endif
#define _zp_classes_included

#include "zombie_plague.inc"

// Zombie Classes (24 total)
static const ZOMBIE_CLASSES[][] = {
    // Level 1
    "Regenerator",        // 0 - 4000 HP, 280 speed, Regenerate HP
    // Level 5
    "WallBanger",          // 1 - 4500 HP, 300 speed
    // Level 9
    "Copycat",             // 2 - 6000 HP, 340 speed
    // Level 13
    "Miss Doctor",         // 3 - 7500 HP, 360 speed
    // Level 17
    "The Stinger",         // 4 - 8500 HP, 390 speed, Place traps [G]
    // Level 21
    "The Destroyer",       // 5 - 9500 HP, 435 speed, Remove armor in 1 hit
    // Level 25
    "The Weapons Blocker", // 6 - 10000 HP, 480 speed, Block enemy weapons
    // Level 29
    "Boomer",              // 7 - 12000 HP, 510 speed, Vomit to block vision [E]
    // Level 33
    "The Teleportator",    // 8 - 11000 HP, 535 speed, Teleport
    // Level 37
    "The Weapon Thrower",  // 9 - 12500 HP, 560 speed, Throw enemy weapon [Click 2]
    // Level 41
    "Smoker",              // 10 - 13000 HP, 580 speed, Smoke attack
    // Level 45
    "Flamer",              // 11 - 14000 HP, 605 speed, Fire attack
    // Level 49
    "Killer 007",          // 12 - 10000 HP, 520 speed
    // Level 53
    "The Witch",           // 13 - 14500 HP, 640 speed
    // Level 57
    "The Radioactive",     // 14 - 15000 HP, 655 speed, Radioactive boost [R]
    // Level 61
    "The Mad Dog",         // 15 - 11000 HP, 670 speed
    // Level 65
    "Predator",            // 16 - 9600 HP, 685 speed
    // Level 69
    "Mermaid",             // 17 - 12000 HP, 700 speed
    // Level 73
    "The Detonator",       // 18 - 13750 HP, 725 speed, Explosion
    // Level 77
    "The Steamer Killer",  // 19 - 14750 HP, 750 speed
    // Level 81
    "Balthazar",           // 20 - 15400 HP, 770 speed, Swap position
    // Level 85
    "The Sniper",          // 21 - 15600 HP, 800 speed
    // Level 91
    "The Rocket Zombie",   // 22 - 15750 HP, 830 speed, Rocket
    // Level 100
    "Mirror Zombie"        // 23 - 10000 HP, 888 speed, Reflect bullets
};

// Human Classes (24 total)
static const HUMAN_CLASSES[][] = {
    "Ryner",        // 0 - 120 HP, 280 speed
    "Yuanshu",       // 1 - 130 HP, 300 speed
    "Faurel",        // 2 - 145 HP, 340 speed
    "Mi Zhu",        // 3 - 145 HP, 360 speed
    "Guosi",         // 4 - 170 HP, 390 speed
    "Hegin",         // 5 - 200 HP, 435 speed
    "Eris",          // 6 - 230 HP, 480 speed
    "TiirX",         // 7 - 255 HP, 510 speed
    "Lubu",          // 8 - 270 HP, 535 speed
    "FahL",          // 9 - 300 HP, 560 speed
    "AstaL",         // 10 - 320 HP, 580 speed
    "KieFer",        // 11 - 350 HP, 605 speed
    "Biao",          // 12 - 360 HP, 620 speed
    "RumiBul",       // 13 - 370 HP, 640 speed
    "TalRome",       // 14 - 380 HP, 655 speed
    "PasuuR",        // 15 - 390 HP, 670 speed
    "PueKa",         // 16 - 400 HP, 685 speed
    "LuCile",        // 17 - 430 HP, 700 speed
    "SioN",          // 18 - 450 HP, 725 speed
    "AnuBis",        // 19 - 465 HP, 750 speed
    "DiavoL",        // 20 - 480 HP, 770 speed
    "Unknown",       // 21 - 500 HP, 800 speed
    "LuciFer",       // 22 - 525 HP, 830 speed
    "The King"       // 23 - 600 HP, 888 speed
};

// Class stats
enum ClassStats {
    CS_HP,
    CS_SPEED,
    CS_ARMOR,
    CS_DAMAGE
};

// ==================== NATIVES ====================

native ZP_Class_GetInfo(class_id, is_zombie, ClassStats:data[]);
native ZP_Class_GetName(class_id, is_zombie, name[], len);
native ZP_Class_GetUnlockLevel(class_id, is_zombie);
native ZP_Class_IsUnlocked(player, class_id, is_zombie);
