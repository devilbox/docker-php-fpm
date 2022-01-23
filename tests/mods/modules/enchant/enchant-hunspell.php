<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);

// FIXME: Currently disabled for PHP 7.3 and PHP 7.4
if (PHP_MAJOR_VERSION == 7) {
	if (PHP_MINOR_VERSION == 3 || PHP_MINOR_VERSION == 4) {
		echo 'SKIP';
		exit(0);
	}
}

/**
 * IMPORTANT:
 * ----------
 * The Myspell backend has been renamed to Hunspell to match the upstream
 * project. Users with their own enchant.ordering files will need to change
 * "myspell" to "hunspell" (as of enchant 2.0)
 * https://github.com/AbiWord/enchant/blob/master/NEWS
 */
// Only available since 5.4.0
if (version_compare(PHP_VERSION, '7.3.0', '<')) {
	echo 'SKIP';
	exit(0);
}

$backend = 'hunspell';

$tag = 'en_US';
if (($r = enchant_broker_init()) === FALSE) {
	echo 'FAIL: enchant_broker_init()';
	exit(1);
}
if (($bprovides = enchant_broker_describe($r)) === FALSE) {
	echo 'FAIL: enchant_broker_describe()';
	exit(1);
}

foreach ($bprovides as $be) {
	if ($be['name'] == $backend) {
		echo 'OK';
		exit(0);
	}
}
echo 'FAIL: "'. $backend . '" not available';
exit(1);
