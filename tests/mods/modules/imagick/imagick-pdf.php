<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);

$PHP_VERSION = str_replace('-dev', '', PHP_VERSION);

// Only available since 5.3.0 (PHP 5.3 and 5.4 segfaults)
if (version_compare($PHP_VERSION, '5.5.0', '<')) {
        echo 'SKIP';
        exit(0);
}
// FIXME: Currently not supported on PHP 8
if (version_compare($PHP_VERSION, '8.0.0', '>=')) {
        echo 'SKIP';
        exit(0);
}

$dir = realpath(dirname(__FILE__));
$file = $dir . DIRECTORY_SEPARATOR . 'dummy.pdf';

$img = new Imagick();

if ($img->readImage($file) !== True) {
	echo 'FAIL: newImage()';
	exit(1);
}
echo 'OK';
