<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Config;

class AppKeyValidationMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        $storedAppKey = env('APP_KEY');

        $appKey = $request->input('app_key');

        if ($appKey !== $storedAppKey) {
            return response()->json(['message' => 'Invalid app key'], 401);
        }

        return $next($request);
    }
}
