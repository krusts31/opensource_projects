-- Remove the old version to be safe
DROP USER IF EXISTS 'hproxy'@'%';

-- Create the user with no password
CREATE USER 'hproxy'@'%';

-- Ensure changes are live
FLUSH PRIVILEGES;
