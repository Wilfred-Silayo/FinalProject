<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileUpdateRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\View\View;
use Illuminate\Support\Facades\Storage;
use App\Http\Middleware\NoCacheMiddleware;

class ProfileController extends Controller
{
    /**
     * Display the user's profile form.
     */
     //Disable caches using no cache middleware
     public function __construct()
     {
         $this->middleware(NoCacheMiddleware::class);
     }

    public function index(): View
    {
        $user=Auth::user();
        return view('profile', [
            'user' => $user,
        ]);
    }

    public function edit(Request $request): View
    {
        return view('edit_profile', [
            'user' => $request->user(),
        ]);
    }

    /**
     * Update the user's profile information.
     */
    public function update(Request $request): RedirectResponse
    {
        $username=Auth::user()->username;
        $request->validate([
            'email' => ['nullable', 'string', 'email', 'max:255', 'unique:users,email,'.$username.',username'],
            'firstName' => ['required', 'string'],
            'lastName' => ['required', 'string'],
        ]); 
       $user=Auth::user();
        $user->update([
            'email' => $request->filled('email') ? $request->email : $admin->email,
            'firstName' => $request->firstName,
            'lastName' => $request->lastName,
        ]);
        
        return back()->with('info','Profile updated successfully');
    }

    public function store(Request $request)
    {
    $request->validate([
        'profile_photo' => ['required', 'image', 'max:2048'], // Max file size is 2MB
    ]);

    $user = Auth::user();
    $file = $request->file('profile_photo');
    $extension = $file->getClientOriginalExtension();
    $filename = $user->username . '_' . time() . '.' . $extension;
    $path = $file->storeAs('public', $filename);
    
    // Check if the new photo is not equal to the default photo "user.png"
    if ($user->profile_photo !== 'user.png') {
        // Delete the old photo
        Storage::delete('public' . $user->profile_photo);
    }
    
    $user->profile_photo = $filename;
    $user->save();
    return back()->with('info', 'Profile Photo Updated Successfully');
    }
}

