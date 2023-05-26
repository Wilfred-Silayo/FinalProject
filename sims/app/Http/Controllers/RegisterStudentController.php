<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Http\Middleware\NoCacheMiddleware;
use App\Models\User;
use App\Imports\StudentImport;
use Maatwebsite\Excel\Facades\Excel;

class RegisterStudentController extends Controller
{
    //Disable caches using no cache middleware
    public function __construct()
    {
        $this->middleware(NoCacheMiddleware::class);
    }

    public function index(){
        $students = User::where('role','student')->paginate(10);
        return view('admin.student.index',['students'=>$students]);
    }

    public function create(){
        return view('admin.student.create');
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
            'role'=>'student',
            'password' => Hash::make(strtoupper($request->lastName)),
            'firstName'=>ucfirst($request->firstName),
            'lastName'=>ucfirst($request->lastName),
        ]);

        return redirect()->route('register.student')->with('info','Student Registered successfully');

    }

    public function upload(Request $request){
        $request->validate([
            'file'=>['required','mimes:xls,xlsx,csv']
        ]);

        $file=$request->file(key:'file');
        Excel::import(new StudentImport(),$file);
        return back()->with('status','Students Imported successfully');
    }

    public function edit($username){
        $username = str_replace('-', '/', $username);
        $student = User::where('username', $username)->first();
        return view('admin.student.edit',['student'=> $student]);
    }

    public function update(Request $request,$username){
        $username = str_replace('-','/',$username);
        $request->validate([
            'email' => ['nullable', 'string', 'email', 'max:255', 
            'unique:users,email,'.$username.',username'],
            'firstName'=>['required','string'],
            'lastName'=>['required','string'],
        ]);
        $student = User::where('username', $username)->firstOrFail();
        $student->update([
            'email' => $request->filled('email') ? $request->email : $student->email,
            'role'=>'student',
            'firstName'=>ucfirst($request->firstName),
            'lastName'=>ucfirst($request->lastName),
        ]);
        return redirect()->route('register.student')->with('info','Student updated successfully');
    }

    
    public function destroy($username){
        $username = str_replace('-', '/', $username);
        $student = User::where('username', $username)->first();
        $student->delete();

        return back()->with('info', 'Student deleted successfully');
    }

    public function search(Request $request)
    {
        $search = $request->query('search');

        if (!is_null($search)) {
            $students = User::where('role', 'student')
            ->where(function ($query) use ($search) {
                $query->where('firstName', 'like', '%' . $search . '%')
                    ->orWhere('lastName', 'like', '%' . $search . '%')
                    ->orWhere('email', 'like', '%' . $search . '%')
                    ->orWhere('userName', 'like', '%' . $search . '%');
            })
            ->paginate(10);
        

            return view('admin.student.index')->with('students', $students);
        } else {
            return back()->with('error', 'Please enter a search query');
        }
    }

}
