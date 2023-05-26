@extends('layouts.app')
@section('title', 'dashboard')
@section('content')

<div class="container bg-white">
    <div class="row d-flex justify-content-between mb-2">
        <div class="row mt-3 mb-2">
            <h5>Welcome back: <span class="text-primary">{{ auth()->user()->firstName }}
                    {{ auth()->user()->lastName }}
                </span></h5>
        </div>
    </div>
    <div class="row mb-2">
        @if($hasToken)
        <div class="alert alert-success">
            You have a new social  verification token <span><a href="{{route('social.student')}}"> click here</a> to get
                it</span>
        </div>
        @endif
    </div>
</div>


@endsection