-- Drop triggers
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop indexes
DROP INDEX IF EXISTS idx_groups_created_by;
DROP INDEX IF EXISTS idx_files_uploaded_by;
DROP INDEX IF EXISTS idx_files_group_id;
DROP INDEX IF EXISTS idx_user_groups_group_id;
DROP INDEX IF EXISTS idx_user_groups_user_id;
DROP INDEX IF EXISTS idx_users_email;

-- Drop tables in reverse order of creation (due to foreign keys)
DROP TABLE IF EXISTS files;
DROP TABLE IF EXISTS user_groups;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS users;
