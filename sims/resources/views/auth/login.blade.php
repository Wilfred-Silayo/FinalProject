@extends('layouts.app')
@section('title','Login')
@section('content')
<div class="container-fluid" style="min-height:87vh;">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card bg-white">
                <div class="card-header bg-secondary text-white">{{ __('Login') }}</div>

                <div class="card-body">
                    <form method="POST" action="{{ route('store') }}">
                        @if(session('error'))
                        <div id="error-message" class="alert alert-warning " role="alert">
                            <strong>{{ session('error') }}</strong>
                        </div>
                        @endif
                        @if(session('status'))
                        <div id="status-message" class="alert alert-success" role="alert">
                            <strong>{{ session('status') }}</strong>
                        </div>
                        @endif
                        @csrf

                        <div class="mb-3 row">
                            <label for="username" class="form-label">{{__('Username')}}</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa fa-user"></i></span>
                                <input type="text" class="form-control @error('username') is-invalid @enderror"
                                    autocomplete="username" id="username" name="username" placeholder="Enter Username">
                                @error('username')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>

                        <div class="mb-3 row">
                            <label for="password" class="form-label">Password</label>

                            <div class="input-group">
                                <span class="input-group-text"><i class="fa fa-lock"></i></span>
                                <input id="password" type="password"
                                    class="form-control @error('password') is-invalid @enderror" name="password"
                                    placeholder="Enter password">

                                <div class="input-group-append">
                                    <button type="button" class="btn btn-light rounded-left rounded-right btn-eye"
                                        id="togglePassword"><i class="fa fa-eye"></i></button>
                                </div>
                                @error('password')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                                @enderror
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6 ">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="remember" id="remember"
                                        value="{{ old('remember') ? 'checked' : '' }}">

                                    <label class="form-check-label" for="remember">
                                        {{ __('Remember Me') }}
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <div class="d-flex justify-content-between">
                                <button type="submit" class="btn offset-4 btn-secondary">
                                    {{ __('Login') }}
                                </button>
                                @if (Route::has('password.request'))
                                <a class="btn btn-link ms-4 ps-4" href="{{ route('password.request') }}">
                                    {{ __('Forgot Your Password?') }}
                                </a>
                                @endif
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="{{asset('scripts/visibility.js')}}"></script>
@endsection