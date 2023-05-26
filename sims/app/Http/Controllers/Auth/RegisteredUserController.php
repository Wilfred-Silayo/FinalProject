<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\SocialToken;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;


class RegisteredUserController extends Controller
{

    public function dashboard(): View
    {
        $user = auth()->user();
        
        if ($user->hasRole('admin')) {
            $studentsCount = User::where('role', 'student')->count();
            $lecturersCount = User::where('role', 'lecturer')->count();
            
            return view('admin_dashboard', [
                'studentsCount' => $studentsCount,
                'lecturersCount' => $lecturersCount,
            ]);
        } 


        
        /*****************
         * lecturers
         */
        elseif ($user->hasRole('lecturer')) {
            
            $user = auth()->user()->username;
            $hasToken = SocialToken::where('user_id',$user)->exists();

            return view('lecturer_dashboard', [
               'hasToken' => $hasToken, 
            ]);
        } 
        /**************************************
         * 
         * students
         */
        
        else {
            $user = auth()->user()->username;
            $hasToken = SocialToken::where('user_id',$user)->exists();

            return view('student_dashboard', [
                'hasToken' => $hasToken, 
            ]);
        } 
    }
    

    
}
