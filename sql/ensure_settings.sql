-- SQL Script to ensure settings columns exist in the users table
USE ocean_view_db;

-- Add is_dark_mode if it doesn't exist
SET @dbname = DATABASE();
SET @tablename = "users";
SET @columnname = "is_dark_mode";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE users ADD COLUMN is_dark_mode BOOLEAN DEFAULT FALSE;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add is_email_notif if it doesn't exist
SET @columnname = "is_email_notif";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE users ADD COLUMN is_email_notif BOOLEAN DEFAULT TRUE;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add is_browser_notif if it doesn't exist
SET @columnname = "is_browser_notif";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE users ADD COLUMN is_browser_notif BOOLEAN DEFAULT FALSE;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Ensure default values for existing rows if they were NULL
UPDATE users SET is_dark_mode = FALSE WHERE is_dark_mode IS NULL;
UPDATE users SET is_email_notif = TRUE WHERE is_email_notif IS NULL;
UPDATE users SET is_browser_notif = FALSE WHERE is_browser_notif IS NULL;
