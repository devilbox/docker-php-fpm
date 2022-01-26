<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);


// Only available since PHP 8.1.x
if (version_compare(PHP_VERSION, '8.1.0', '<=')) {
	echo 'SKIP';
	exit(0);
}

// Check for support
if (!function_exists('imageavif')) {
	echo 'FAIL: imageavif()';
	exit(1);
}

echo 'OK';
