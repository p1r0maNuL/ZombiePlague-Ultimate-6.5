/*
 * Zombie Plague Ultimate 6.5
 * Main constants and natives definitions
 * 
 * File: zombie_plague.inc
 * Version: 6.5
 */

#if defined _zombie_plague_included
    #endinput
#endif
#define _zombie_plague_included

// ==================== CONSTANTS ====================

// Max players
#define MAX_PLAYERS 32
#define MAX_CLASSES_ZOMBIE 24
#define MAX_CLASSES_HUMAN 24
#define MAX_GAME_MODES 11

// Player data
define MAX_NAME_LENGTH 32
define MAX_STEAMID_LENGTH 32
define MAX_PASSWORD_LENGTH 64

// Levels
#define MAX_LEVEL 100
#define MIN_LEVEL 1

// Credits
#define MAX_CREDITS 999999

// Game mode IDs
#define GAMEMODE_INFECTION 0
#define GAMEMODE_NEMESIS 1
#define GAMEMODE_SURVIVOR 2
#define GAMEMODE_SNIPER 3
#define GAMEMODE_ASSASSIN 4
#define GAMEMODE_SWARM 5
#define GAMEMODE_MULTIPLE_INFECTION 6
#define GAMEMODE_PLAGUE 7
#define GAMEMODE_ASSASSINS_VS_SNIPER 8
#define GAMEMODE_ARMAGEDDON 9
#define GAMEMODE_DRAGON 10

// Player roles
#define ROLE_HUMAN 0
#define ROLE_ZOMBIE 1
#define ROLE_NEMESIS 2
#define ROLE_SURVIVOR 3
#define ROLE_SNIPER 4
#define ROLE_ASSASSIN 5
#define ROLE_SWARM 6
#define ROLE_DRAGON 7

// ==================== ENUMS ====================

enum ZombieClass {
    ZC_ID,
    ZC_NAME[32],
    ZC_LEVEL_UNLOCK,
    ZC_HP,
    ZC_SPEED,
    ZC_DAMAGE,
    ZC_HAS_ABILITY
};

enum HumanClass {
    HC_ID,
    HC_NAME[32],
    HC_LEVEL_UNLOCK,
    HC_HP,
    HC_SPEED,
    HC_ARMOR
};

enum PlayerData {
    PD_USERID,
    PD_STEAMID[MAX_STEAMID_LENGTH],
    PD_NAME[MAX_NAME_LENGTH],
    PD_LEVEL,
    PD_XP,
    PD_CREDITS,
    PD_VIP_LEVEL,
    PD_VIP_EXPIRY,
    PD_ZOMBIE_CLASS,
    PD_HUMAN_CLASS,
    PD_CURRENT_ROLE,
    PD_HP,
    PD_ARMOR,
    PD_KILLS,
    PD_DEATHS,
    PD_INFECTS
};

// ==================== FORWARDS ====================

forward ZP_OnGameModeStart(gamemode_id);
forward ZP_OnGameModeEnd(gamemode_id, winner);
forward ZP_OnPlayerInfected(player, infector);
forward ZP_OnPlayerCured(player);
forward ZP_OnPlayerKilled(victim, killer);
forward ZP_OnPlayerLevelUp(player, new_level);
forward ZP_OnPlayerCreditChange(player, amount);
forward ZP_OnVIPStatusChanged(player, vip_level);
forward ZP_OnClassChanged(player, class_id, is_zombie);

// ==================== NATIVES ====================

// Player functions
native ZP_GetPlayerLevel(player);
native ZP_SetPlayerLevel(player, level);
native ZP_GetPlayerCredits(player);
native ZP_AddPlayerCredits(player, amount);
native ZP_RemovePlayerCredits(player, amount);
native ZP_GetPlayerXP(player);
native ZP_AddPlayerXP(player, amount);

// Class functions
native ZP_GetPlayerZombieClass(player);
native ZP_SetPlayerZombieClass(player, class_id);
native ZP_GetPlayerHumanClass(player);
native ZP_SetPlayerHumanClass(player, class_id);

// Role functions
native ZP_GetPlayerRole(player);
native ZP_SetPlayerRole(player, role);
native ZP_InfectPlayer(player);
native ZP_CurePlayer(player);

// VIP functions
native ZP_GetPlayerVIPLevel(player);
native ZP_SetPlayerVIPLevel(player, level);
native ZP_IsPlayerVIP(player);
native ZP_GetVIPExpiry(player);

// Game mode functions
native ZP_GetCurrentGameMode();
native ZP_SetGameMode(gamemode_id);
native ZP_GetGameModeInfo(gamemode_id, info[]);

// Utility
native ZP_GetPlayerData(player, PlayerData:data);
native ZP_SetPlayerData(player, PlayerData:data, value);
