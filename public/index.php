<?php

use App\Kernel;

require dirname(__DIR__).'/vendor/autoload_runtime.php';

// Use environment variables directly
return function (array $context) {
    $env = $_SERVER['APP_ENV'] ?? 'prod';
    $debug = (bool) ($_SERVER['APP_DEBUG'] ?? ($env !== 'prod'));

    return new Kernel($env, $debug);
};

?>
