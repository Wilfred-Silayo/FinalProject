@extends('layouts.app')
@section('title','Password')
@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card bg-white dark:bg-gray-800 shadow-sm rounded-lg">
                <div class="card-body">
                    <div class="max-w-xl">
                        <section>
                            <header>
                                <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">
                                    Update Password
                                </h2>

                                <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                                    Ensure your account is using a long, random password to stay secure.
                                </p>
                            </header>

                            <form method="post" action="{{ route('password.update') }}" class="mt-6 py-6">
                                @if (session('status') === 'password-updated')
                               <div class="alert alert-success fade show">
                               {{ session('status') }}
                               </div>
                                @endif
                                @if (session('error'))
                                <div id="successmessage" class="alert alert-warning fade show"
                                    role="alert">
                                    <strong>{{ session('error') }}</strong>
                                    
                                </div>
                                @endif
                                @csrf
                                @method('put')

                                <div>
                                    <label for="current_password" class="form-label text-md-end">
                                        {{ __('Current Password') }}
                                    </label>
                                    <input id="current_password" name="current_password" type="password"
                                        class="mb-3 form-control @error('current_password') is-invalid @enderror"
                                        autocomplete="current-password" />
                                    @error('current_password')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>

                                <div>
                                    <label for="password" class="form-label text-md-end">
                                        {{ __('New Password') }}
                                    </label>
                                    <input id="password" name="password" type="password"
                                        class=" mb-3 form-control @error('password') is-invalid @enderror"
                                        autocomplete="new-password" />
                                    @error('password')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>

                                <div>
                                    <label for="password_confirmation" class="form-label text-md-end">
                                        {{ __('Confirm Password') }}
                                    </label>
                                    <input id="password_confirmation" name="password_confirmation" type="password"
                                        class="mb-3 form-control @error('password_confirmation') is-invalid @enderror"
                                        autocomplete="new-password" />
                                    @error('password_confirmation')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>

                                <div class="flex items-center gap-4">
                                    <button type="submit" class="px-4 py-2 text-white btn btn-secondary">
                                        {{ __('Save') }}
                                    </button>
                                </div>
                            </form>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection