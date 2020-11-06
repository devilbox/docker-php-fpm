<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);


$dir  = realpath(dirname(__FILE__));
$font = $dir . DIRECTORY_SEPARATOR . 'ptsans-regular.ttf';

if ( ($bbox = imagettfbbox(10, 0, $font, 'текст на русском языке не работает')) === FALSE ) {
	echo 'FAIL: imagettfbox()';
	exit(1);
}
echo 'OK';
