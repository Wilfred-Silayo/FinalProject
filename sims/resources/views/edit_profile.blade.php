@extends('layouts.app')
@section('title', 'Profile Photo')
@section('content')
<div class="container">
    <div class="row">
        @if (session('info'))
        <div id="success-message" class="alert alert-success fade show" role="alert">
            <strong>{{ session('info') }}</strong>
        </div>
        @endif
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Profile Information</h4>
                </div>
                <div class="card-body">
                    <form action="{{route('profile.update',str_replace('/','-',$user->username))}}" id="edit-admin-form"
                        method="POST">
                        @csrf
                        @method('patch')
                        <div class="row mb-3">
                            <label for="username" class="col col-form-labelform-label">{{__('Username')}}</label>
                            <div class="col-8">
                                <input id="username" type="text"
                                    class="form-control @error('username') is-invalid @enderror"
                                    value="{{ old('username',$user->username) }}" name="username"
                                    autocomplete="username" readonly>
                                @error('username')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="firstName" class="col col-form-labelform-label">{{__('First Name')}}</label>
                            <div class="col-8">
                                <input id="firstName" type="text"
                                    class="form-control @error('firstName') is-invalid @enderror"
                                    value="{{ old('firstName',$user->firstName) }}" name="firstName"
                                    autocomplete="firstName">
                                @error('firstName')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="lastName" class="col col-form-labelform-label">{{__('Last Name')}}</label>
                            <div class="col-8">
                                <input id="lastName" type="text"
                                    class="form-control @error('lastName') is-invalid @enderror"
                                    value="{{ old('lastName',$user->lastName) }}" name="lastName"
                                    autocomplete="lastName">
                                @error('lastName')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="email" class="col col-form-labelform-label">{{__('Email Address')}}</label>
                            <div class="col-8">
                                <input id="email" type="email" class="form-control @error('email') is-invalid @enderror"
                                    name="email" value="{{ old('email',$user->email) }}" autocomplete="email">
                                @error('email')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>

                    </form>
                </div>
                <div class=" card-footer ">
                    <div class="col-4 mb-4">
                        <button type="button" class="btn btn-primary btn-sm btn-flat"
                            onclick="submitForm()">Update</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
        function submitForm() {
            document.getElementById("edit-admin-form").submit();
        }
        </script>

    </div>
</div>
@endsection