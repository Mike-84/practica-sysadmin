CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY 'Mik84';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'%';
FLUSH PRIVILEGES;