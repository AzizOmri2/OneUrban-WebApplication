<?php

use App\Kernel;
use Symfony\Component\Dotenv\Dotenv;

// Load .env only if not in production
if ($_SERVER['APP_ENV'] ?? 'prod' !== 'prod') {
    (new Dotenv())->loadEnv(dirname(__DIR__).'/.env');
}

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return function (array $context) {
    return new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
};
