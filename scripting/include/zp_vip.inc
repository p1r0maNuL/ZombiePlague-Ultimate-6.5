/*
 * Zombie Plague Ultimate 6.5
 * VIP System definitions
 * 
 * File: zp_vip.inc
 * Version: 6.5
 */

#if defined _zp_vip_included
    #endinput
#endif
#define _zp_vip_included

#include "zombie_plague.inc"

// VIP Levels
#define VIP_LEVEL_NONE 0
#define VIP_LEVEL_FREE 1
#define VIP_LEVEL_PAID 2

// VIP Benefits
enum VIPBenefit {
    VB_TRIPLE_JUMP = (1 << 0),
    VB_ARMOR_100 = (1 << 1),
    VB_UNLIMITED_AMMO = (1 << 2),
    VB_NO_FALL_DAMAGE = (1 << 3),
    VB_DAMAGE_MULTIPLIER = (1 << 4),
    VB_BONUS_CREDITS = (1 << 5),
    VB_HP_REGEN = (1 << 6),
    VB_VIP_SKIN = (1 << 7)
};

// ==================== NATIVES ====================

native ZP_VIP_IsActive(player);
native ZP_VIP_GetLevel(player);
native ZP_VIP_SetLevel(player, level);
native ZP_VIP_GetExpiry(player);
native ZP_VIP_SetExpiry(player, timestamp);
native ZP_VIP_HasBenefit(player, benefit);
native ZP_VIP_ApplyBenefits(player);
