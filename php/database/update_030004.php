<?php

###
# @name			Update to version 3.0.4
# @copyright	2015 by Web Essentials
###

if (!defined('LYCHEE')) exit('Error: Direct access is not allowed!');

# Add filteringResolution to settings
$query	= Database::prepare($database, "SELECT `key` FROM `?` WHERE `key` = 'filteringResolution' LIMIT 1", array(LYCHEE_TABLE_SETTINGS));
$result	= $database->query($query);
if ($result->num_rows===0) {
	$query	= Database::prepare($database, "INSERT INTO `?` (`key`, `value`) VALUES ('filteringResolution', '')", array(LYCHEE_TABLE_SETTINGS));
	$result	= $database->query($query);
	if (!$result) {
		Log::error($database, 'update_030004', __LINE__, 'Could not update database (' . $database->error . ')');
		return false;
	}
}

# Add filteringAspectRatio to settings
$query	= Database::prepare($database, "SELECT `key` FROM `?` WHERE `key` = 'filteringAspectRatio' LIMIT 1", array(LYCHEE_TABLE_SETTINGS));
$result	= $database->query($query);
if ($result->num_rows===0) {
	$query	= Database::prepare($database, "INSERT INTO `?` (`key`, `value`) VALUES ('filteringAspectRatio', '')", array(LYCHEE_TABLE_SETTINGS));
	$result	= $database->query($query);
	if (!$result) {
		Log::error($database, 'update_030004', __LINE__, 'Could not update database (' . $database->error . ')');
		return false;
	}
}

# Set version
if (Database::setVersion($database, '030004')===false) return false;

?>
