@extends('layouts.app')
@section('title', 'Profile')
@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-7 col-sm-7 offset-2">
            <div class="row">
                <h3 class="card-title text-center">Profile Information</h3>
            </div>
            <div class="col">
                <table class="table table-bordered table-striped">
                    <tr>
                        <td>Username</td>
                        <td>{{$user->username}}</td>
                    </tr>
                    <tr>
                        <td>Full Name</td>
                        <td>{{$user->firstName}} {{$user->middleName}} {{$user->lastName}}</td>
                    </tr>
                    <tr>
                        <td>Email Address</td>
                        <td>{{$user->email}}</td>
                    </tr>
                    <tr>
                        <td>Role</td>
                        <td>{{$user->role}}</td>
                    </tr>

                </table>
                <div class="col-md-4">
                    <a href="{{ route('profile.edit') }}" class="btn btn-primary">Update Profile</a>
                </div>

            </div>

        </div>
    </div>
    @endsection