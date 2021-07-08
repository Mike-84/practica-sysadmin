<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpressuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'Mik84' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'po/QJYQ}_ZAFNi/%||fKcFXmkikRb[+$wYbRU;o!xaf?3)7PwL(`a[I9yZRW@]_F');
define('SECURE_AUTH_KEY',  'Y|8Tz0=H>Pas1_cA9Gc>IE% ir|eNcS>bh(]z0:-s!8bcx|-q_c#k^+3@9znW-2x');
define('LOGGED_IN_KEY',    '|:#IS[;B.[xA]oXGopj5~3gfhg-:=m!5cm$10`:lkH$,3G-oG;N[D-)c@=}Hhh:+');
define('NONCE_KEY',        'g/u,i}|e_>X2C1M$j(*0~Co+^AP4j[Sc.3~:P+:Vd||(a-RKLe(/F3mUfM;Ihr;Y');
define('AUTH_SALT',        'Rf=)HWNcCME-W[>^z+j-s_x+pS}^/N8Kxk`(tHc(3xuM7~w0}]]7+LL{4!?ZT{pQ');
define('SECURE_AUTH_SALT', '^C}nB9BeV -$+|jB3AG*gSV@[!+Lj=GpN**>gFRg3jq8)YDN=D0#cv|}w?N}{_%!');
define('LOGGED_IN_SALT',   'B1O4fM)]#[n8GwI/++>McMbAfcWz;MiF|7,>U!2FS5RS_`d7?tR{[mbD]%8A>zE+');
define('NONCE_SALT',       'tXq;+F1LI.|& O&f{5M;R?K4m|>jwO|!vbmX>!`rP-! oUtLmqnW7z=z5l9x^&y`');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
define('FS_METHOD', 'direct');
