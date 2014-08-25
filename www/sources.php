<?php
//TODO remove this file
require_once('vendor/autoload.php');

use WorldNews\BaseSource;
use WorldNews\Sources;
use WorldNews\Sources\Reddit;

//Approved classes, required for get_declared_classes() in BaseSource to work
new Reddit();

//End approved classes
$sources = BaseSource::getAllSources();

header("Content-Type: application/json");
echo $sources->toJson();
