<?php
/**
 * This page should print 'OK' if everything works,
 * 'FAIL' or nothing if an error occured.
 */
ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
error_reporting(-1);


$backend = 'myspell';

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
