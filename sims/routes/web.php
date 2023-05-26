<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\RegisterStudentController;
use App\Http\Controllers\SocialTokenController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\RegisterLecturerController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::middleware('auth')->group(function () {
    Route::get('/dashboard',[RegisteredUserController::class,'dashboard'])
    ->name('dashboard');
    Route::get('/profile', [ProfileController::class, 'index'])->name('profile');
    Route::get('/profile/edit', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::put('/profile/photo/update', [ProfileController::class, 'store'])->name('profile.store');
    Route::patch('/profile/update', [ProfileController::class, 'update'])->name('profile.update');
});


/***************************************************************************
 * students routes
 * 
 */
Route::prefix('student')->middleware('student')->group(function () {
    Route::get('/social/Tokens', [SocialTokenController::class, 'getStudentToken'])
    ->name('social.student');

});


/***************************************************************************
 * lecturer routes
 * 
 */

Route::prefix('lecturer')->middleware('lecturer')->group(function () {
    Route::get('/social/Tokens', [socialTokenController::class, 'getLecturerToken'])
    ->name('social.lecturer');

});

/************************************************************************
 * admin routes
 *  */ 
Route::prefix('admin')->middleware('admin')->group(function () {
    //students
    Route::get('/register/student', [RegisterStudentController::class, 'index'])
    ->name('register.student');

    Route::get('/new/student', [RegisterStudentController::class, 'create'])
    ->name('create.student');

    Route::post('/store/student', [RegisterStudentController::class, 'store'])
    ->name('store.student');

    Route::get('/edit/student/{username}', [RegisterStudentController::class, 'edit'])
    ->name('edit.student');

     Route::put('/update/student/{username}', [RegisterStudentController::class, 'update'])
    ->name('update.student');

    Route::post('/upload/student', [RegisterStudentController::class, 'upload'])
    ->name('upload.student');

    Route::delete('/delete/student{username}', [RegisterStudentController::class, 'destroy'])
    ->name('destroy.student');

    Route::get('/search/student', [RegisterStudentController::class, 'search'])
    ->name('search.student');

    //lecturers
    Route::get('/register/lecturer', [RegisterLecturerController::class, 'index'])
    ->name('register.lecturer');

    Route::get('/new/lecturer', [RegisterLecturerController::class, 'create'])
    ->name('create.lecturer');

    Route::post('/store/lecturer', [RegisterLecturerController::class, 'store'])
    ->name('store.lecturer');

    Route::post('/upload/lecturer', [RegisterLecturerController::class, 'upload'])
    ->name('upload.lecturer');

    Route::get('/edit/lecturer/{username}', [RegisterLecturerController::class, 'edit'])
    ->name('edit.lecturer');

    Route::put('/update/lecturer/{username}', [RegisterLecturerController::class, 'update'])
    ->name('update.lecturer');

    Route::delete('/delete/lecturer/{username}', [RegisterLecturerController::class, 'destroy'])
    ->name('destroy.lecturer');

    Route::get('/search/lecturer', [RegisterLecturerController::class, 'search'])
    ->name('search.lecturer');


});



require __DIR__.'/auth.php';