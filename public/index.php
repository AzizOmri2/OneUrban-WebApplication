<?php

use App\Kernel;
use Symfony\Component\Dotenv\Dotenv;

$envFile = dirname(__DIR__).'/.env';

// Load .env only if it exists and we're not in production
if (file_exists($envFile) && (($_SERVER['APP_ENV'] ?? 'prod') !== 'prod')) {
    (new Dotenv())->loadEnv($envFile);
}

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return function (array $context) {
    return new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
};
