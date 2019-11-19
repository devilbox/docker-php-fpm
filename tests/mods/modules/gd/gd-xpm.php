<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);

// Check for XPM support
// https://www.php.net/manual/en/function.imagetypes.php
if (!(imagetypes() & IMG_XPM)) {
	echo 'FAIL: No XMP support';
	exit(1);
}
echo 'OK';
