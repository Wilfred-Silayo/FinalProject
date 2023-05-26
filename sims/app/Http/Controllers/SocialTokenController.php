<?php

namespace App\Http\Controllers;
use App\Models\SocialToken;
use Illuminate\Support\Facades\Mail;
use App\Http\Middleware\NoCacheMiddleware;

use Illuminate\Http\Request;

class SocialTokenController extends Controller
{
    //Disable caches using no cache middleware
    public function __construct()
    {
        $this->middleware(NoCacheMiddleware::class);
    }

    public function getLecturerToken(){
        
        $user=auth()->user()->username;
        $token = SocialToken::where('user_id',$user)->first();
        return view('lecturer.token')->with('token', $token);
    }

    public function getStudentToken(){

        $user=auth()->user()->username;
        $token = SocialToken::where('user_id',$user)->first();
        return view('student.token')->with('token', $token);
    }

    private function generateToken(Request $request)
    {
        $user = $request->user;

        $userExists = User::where('username', $user)->exists();
    
        if (!$userExists) {
            return response()->json(['message' => 'User not found.'],404);
        }
        
        $existingToken = SocialToken::where('user_id', $user)->first();
        if ($existingToken) {
            $existingToken->delete();
        }
    
        $token = rand(1000, 9999);
    
        while (SocialToken::where('value', $token)->exists()) {
            $token = rand(1000, 9999);
        }
    
        SocialToken::create([
            'user_id' => $user,
            'value' => $token,
        ]);
        
        $recipientEmail = User::where('username', $user)->first()->email;
        $message='We have sent you this email because you
        requested a token for verification of your social account. 
        If you didn\'t send the request please skip this email, 
        and make sure you change your SIMS account password';

        Mail::to($recipientEmail)
        ->send(new TokenGenerated($token, $message));
    
        return response()->json([
            'user'=>$user,
            'message' => 'Token generated successfully. We have sent you the token 
            in your email that you used to register in your College, Institute or University. 
            Also, you can find it in your SIMS account.'
        ],200);
    }

    public function verifyToken(Request $request)
    {
        $token = $request->input('token');
        $user = $request->input('user');
        $socialToken = SocialToken::where('user_id',$user)->where('value', $token)->first();
        if (!$socialToken) {
            return response()->json(['error' => 'Invalid token'], 404);
        }
        
        $socialToken->delete();
        
        return response()->json(['message' => 'Token verified successfully'],200);  
    }


    
}

