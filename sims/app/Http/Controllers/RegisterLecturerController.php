<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Http\Middleware\NoCacheMiddleware;
use App\Models\User;
use App\Imports\LecturerImport;
use Maatwebsite\Excel\Facades\Excel;

class RegisterLecturerController extends Controller
{
    //Disable caches using no cache middleware
    public function __construct()
    {
        $this->middleware(NoCacheMiddleware::class);
    }

    public function index(){
        $lecturers = User::where('role','lecturer')->paginate(10);
        return view('admin.lecturer.index',['lecturers'=>$lecturers]);
    }

    public function create(){
        return view('admin.lecturer.create');
    }

    public function store(Request $request){
        $request->validate([
            'username' => ['required', 'string', 'max:255','unique:'.User::class],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:'.User::class],
            'firstName'=>['required','string'],
            'lastName'=>['required','string'],
        ]);

       User::create([
            'username' => $request->username,
            'email' => $request->email,
            'role'=>'lecturer',
            'password' => Hash::make(strtoupper($request->lastName)),
            'firstName'=>ucfirst($request->firstName),
            'lastName'=>ucfirst($request->lastName),
        ]);

        return redirect()->route('register.lecturer')->with('info','Lecturer Registered successfully');

    }

    public function upload(Request $request){
        $request->validate([
            'file'=>['required','mimes:xls,xlsx,csv']
        ]);

        $file=$request->file(key:'file');
        Excel::import(new LecturerImport(),$file);
        return back()->with('status','Lecturers Imported successfully');
    }

    public function edit($username){
        $username = str_replace('-', '/', $username);
        $lecturer = User::where('username', $username)->first();
        return view('admin.lecturer.edit',['lecturer'=> $lecturer]);
    }

    public function update(Request $request,$username){
        $username = str_replace('-','/',$username);
        $request->validate([
            'email' => ['nullable', 'string', 'email', 'max:255', 
            'unique:users,email,'.$username.',username'],
            'firstName'=>['required','string'],
            'lastName'=>['required','string'],
        ]);
        $lecturer = User::where('username', $username)->firstOrFail();
        $lecturer->update([
            'email' => $request->filled('email') ? $request->email : $lecturer->email,
            'role'=>'lecturer',
            'firstName'=>ucfirst($request->firstName),
            'lastName'=>ucfirst($request->lastName),
        ]);
        return redirect()->route('register.lecturer')->with('info','Lecturer updated successfully');
    }

    
    public function destroy($username){
        $username = str_replace('-', '/', $username);
        $lecturer = User::where('username', $username)->first();
        $lecturer->delete();

        return back()->with('info', 'Lecturer deleted successfully');
    }

    public function search(Request $request)
    {
        $search = $request->query('search');

        if (!is_null($search)) {
            $lecturers = User::where('role', 'lecturer')
            ->where(function ($query) use ($search) {
                $query->where('firstName', 'like', '%' . $search . '%')
                    ->orWhere('lastName', 'like', '%' . $search . '%')
                    ->orWhere('email', 'like', '%' . $search . '%')
                    ->orWhere('userName', 'like', '%' . $search . '%');
            })
            ->paginate(10);
        

            return view('admin.lecturer.index')->with('lecturers', $lecturers);
        } else {
            return back()->with('error', 'Please enter a search query');
        }
    }

}
