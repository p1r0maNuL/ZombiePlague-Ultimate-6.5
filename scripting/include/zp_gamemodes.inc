/*
 * Zombie Plague Ultimate 6.5
 * Game modes definitions
 * 
 * File: zp_gamemodes.inc
 * Version: 6.5
 */

#if defined _zp_gamemodes_included
    #endinput
#endif
#define _zp_gamemodes_included

#include "zombie_plague.inc"

// Game mode info structure
enum GameModeInfo {
    GMI_ID,
    GMI_NAME[32],
    GMI_DESCRIPTION[128],
    GMI_MIN_PLAYERS,
    GMI_CHANCE,
    GMI_ENABLED,
    Float:GMI_SPAWN_DELAY
};

// Game modes configuration
static GameModeData[MAX_GAME_MODES][GameModeInfo] = {
    // GAMEMODE_INFECTION
    {
        GAMEMODE_INFECTION,
        "Infection",
        "One zombie infects all humans",
        2,
        1,
        1,
        2.0
    },
    // GAMEMODE_NEMESIS
    {
        GAMEMODE_NEMESIS,
        "Nemesis",
        "One super zombie (150k HP) vs humans",
        3,
        1,
        1,
        2.0
    },
    // GAMEMODE_SURVIVOR
    {
        GAMEMODE_SURVIVOR,
        "Survivor",
        "One super human (6k HP) vs zombies",
        3,
        1,
        1,
        2.0
    },
    // GAMEMODE_SNIPER
    {
        GAMEMODE_SNIPER,
        "Sniper",
        "Sniper human with explosing zombies on kill",
        4,
        1,
        1,
        2.0
    },
    // GAMEMODE_ASSASSIN
    {
        GAMEMODE_ASSASSIN,
        "Assassin",
        "Assassin zombie (gore effect on kill)",
        4,
        1,
        1,
        2.0
    },
    // GAMEMODE_SWARM
    {
        GAMEMODE_SWARM,
        "Swarm",
        "All players start as zombies",
        10,
        1,
        1,
        2.0
    },
    // GAMEMODE_MULTIPLE_INFECTION
    {
        GAMEMODE_MULTIPLE_INFECTION,
        "Multiple Infection",
        "Multiple zombies at start (proportional to players)",
        6,
        1,
        1,
        2.0
    },
    // GAMEMODE_PLAGUE
    {
        GAMEMODE_PLAGUE,
        "Plague/Apocalypse",
        "Nemesis + Survivor + Multiple Infection combined",
        12,
        1,
        1,
        2.0
    },
    // GAMEMODE_ASSASSINS_VS_SNIPER
    {
        GAMEMODE_ASSASSINS_VS_SNIPER,
        "Assassins vs Sniper",
        "Multiple assassins vs sniper human",
        6,
        1,
        1,
        2.0
    },
    // GAMEMODE_ARMAGEDDON
    {
        GAMEMODE_ARMAGEDDON,
        "Armageddon",
        "Final round: Nemesis + Survivor simultaneously",
        8,
        1,
        1,
        2.0
    },
    // GAMEMODE_DRAGON
    {
        GAMEMODE_DRAGON,
        "Dragon",
        "Dragon ability - ice spit + flight (Press R)",
        5,
        1,
        1,
        2.0
    }
};

// ==================== NATIVES ====================

native ZP_GameMode_GetInfo(gamemode_id, GameModeInfo:data[]);
native ZP_GameMode_Start(gamemode_id);
native ZP_GameMode_End(gamemode_id);
native ZP_GameMode_IsActive(gamemode_id);
native ZP_GameMode_GetNextMode();
