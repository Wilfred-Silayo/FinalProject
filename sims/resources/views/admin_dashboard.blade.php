@extends('layouts.app')
@section('title', 'dashboard')
@section('content')
<div class="container bg-white">
    <div class="row d-flex justify-content-between mb-2">
        <div class="row mt-3 mb-2">
        <h5>Welcome back: <span class="text-primary">{{ auth()->user()->firstName }}
        {{ auth()->user()->lastName }}
        </span></h5>
        <p class="text-dark fw-bold fs-5 mt-2">Report Summary</p>
        </div>
        <div class="row mt-2">
            <div class="col-sm-4 mb-2 ">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total students</h5>
                        <p class="card-text"><strong>{{$studentsCount}}</strong></p>
                        <a href="{{route('register.student')}}" class="btn btn-info">Go To Students</a>
                    </div>
                </div>
            </div>
            <div class="col-sm-4 mb-2 ">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total lecturers</h5>
                        <p class="card-text"><strong>{{$lecturersCount}}</strong></p>
                        <a href="{{route('register.lecturer')}}" class="btn btn-info">Go To Lecturers</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

@endsection