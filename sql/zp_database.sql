-- Zombie Plague Ultimate 6.5 - Database Schema
-- MySQL Database Setup

-- Players table
CREATE TABLE IF NOT EXISTS `zp_players` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `username` VARCHAR(32) NOT NULL,
  `password_hash` VARCHAR(255),
  `level` INT DEFAULT 1,
  `xp` INT DEFAULT 0,
  `credits` INT DEFAULT 0,
  `zombie_class` INT DEFAULT 0,
  `human_class` INT DEFAULT 0,
  `kills` INT DEFAULT 0,
  `deaths` INT DEFAULT 0,
  `infects` INT DEFAULT 0,
  `playtime` INT DEFAULT 0,
  `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VIP table
CREATE TABLE IF NOT EXISTS `zp_vip` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `vip_level` INT DEFAULT 0,
  `expiry` INT DEFAULT 0,
  `access_type` INT DEFAULT 0,
  `access_value` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`steamid`) REFERENCES `zp_players`(`steamid`) ON DELETE CASCADE
);

-- Admin table
CREATE TABLE IF NOT EXISTS `zp_admins` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `admin_level` INT DEFAULT 1,
  `flags` VARCHAR(100),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`steamid`) REFERENCES `zp_players`(`steamid`) ON DELETE CASCADE
);

-- Bans table
CREATE TABLE IF NOT EXISTS `zp_bans` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32),
  `ip` VARCHAR(15),
  `reason` VARCHAR(255),
  `banned_by` VARCHAR(32),
  `ban_length` INT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` INT
);

-- Gags table
CREATE TABLE IF NOT EXISTS `zp_gags` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32),
  `reason` VARCHAR(255),
  `gagged_by` VARCHAR(32),
  `gag_length` INT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` INT
);

-- Whitelist table
CREATE TABLE IF NOT EXISTS `zp_whitelist` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `added_by` VARCHAR(32),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Activity log table
CREATE TABLE IF NOT EXISTS `zp_activity_log` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32),
  `action` VARCHAR(100),
  `details` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX (`steamid`)
);

-- Slot machine tokens table
CREATE TABLE IF NOT EXISTS `zp_slot_tokens` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `tokens` INT DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`steamid`) REFERENCES `zp_players`(`steamid`) ON DELETE CASCADE
);

-- Daily bonus table
CREATE TABLE IF NOT EXISTS `zp_daily_bonus` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `steamid` VARCHAR(32) UNIQUE NOT NULL,
  `last_claimed` INT DEFAULT 0,
  FOREIGN KEY (`steamid`) REFERENCES `zp_players`(`steamid`) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX idx_level ON `zp_players`(`level`);
CREATE INDEX idx_credits ON `zp_players`(`credits`);
CREATE INDEX idx_vip_level ON `zp_vip`(`vip_level`);
CREATE INDEX idx_admin_level ON `zp_admins`(`admin_level`);
