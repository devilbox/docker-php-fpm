<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);


$arr = gd_info();
if (!isset($arr['FreeType Support'])) {
	echo 'FAIL: FreeType Support array key does not exist.';
	exit(1);
}
if ($arr['FreeType Support'] !== TRUE) {
	echo 'FAIL: No FreeType support.';
	exit(1);
}
echo 'OK';
