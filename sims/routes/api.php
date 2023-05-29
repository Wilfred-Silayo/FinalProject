<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SocialTokenController;
use App\Models\User;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('appkey')->group(function () {
    Route::post('/generate/token',[SocialTokenController::class,'generateToken']);
    Route::post('/verify/token',[SocialTokenController::class,'verifyToken']);
});


