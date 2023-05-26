@extends('layouts.app')
@section('title','Register lecturer')
@section('content')
@if (session('status'))
<div class="alert alert-success" role="alert">
    {{ session('status') }}
</div>
@endif
<div class="container bg-white justify-content-center">
    <h2 class="mb-2" id="registerLabel">Register lecturer</h2>
    <hr>
    <form action="{{route('store.lecturer')}}" id="register-lecturer-form" method="POST">
        @csrf
        <div class="row mb-3">
            <label for="username" class="col col-form-labelform-label">{{__('Username')}}</label>
            <div class="col-8">
                <input id="username" type="text" class="form-control @error('username') is-invalid @enderror"
                    value="{{ old('username') }}" name="username" autocomplete="username">
                @error('username')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
                @enderror
            </div>
        </div>
        <div class="row mb-3">
            <label for="firstName" class="col col-form-label form-label">{{__('First Name')}}</label>
            <div class="col-8">
                <input id="firstName" type="text" class="form-control @error('firstName') is-invalid @enderror"
                    value="{{ old('firstName') }}" name="firstName" autocomplete="firstName">
                @error('firstName')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
                @enderror
            </div>
        </div>
        <div class="row mb-3">
            <label for="lastName" class="col col-form-label form-label">{{__('Last Name')}}</label>
            <div class="col-8">
                <input id="lastName" type="text" class="form-control @error('lastName') is-invalid @enderror"
                    value="{{ old('lastName') }}" name="lastName" autocomplete="lastName">
                @error('lastName')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
                @enderror
            </div>
        </div>
        <div class="row mb-3">
            <label for="email" class="col col-form-label form-label">{{__('Email Address')}}</label>
            <div class="col-8">
                <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" name="email"
                    value="{{ old('email') }}" autocomplete="email">
                @error('email')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
                @enderror
            </div>
        </div>

    </form>
    <div class="row mb-4 justify-content-end">
        <div class="col-4 mb-4">
            <button type="button" class="btn btn-success btn-sm btn-flat" onclick="sendForm()">Register</button>
        </div>
    </div>
    <div class="row mt-2 bg-light mb-4">
        <h4 class="text-dark">Use Excel</h4>
        <img src="{{asset('images/sims.jpg')}}" alt="excel sample">
        <div class="row bg-light mt-4">
            <div class="col-md-6">
                <h5 class="text-primary">Note:</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Follow the format above</li>
                    <li class="list-group-item">
                        Use username, firstName, lastName,email as headers
                    </li>
                </ul>

                <style>
                .list-group-flush .list-group-item::before {
                    content: "•";
                    margin-right: 0.5rem;
                }
                </style>
            </div>
            <div class="col-md-6">
                <form action="{{route('upload.lecturer')}}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <div class="mb-3">
                        <label for="formFile" class="form-label">
                            <h5 class="text-primary">Import Excel file only</h5>
                        </label>
                        <div class="col">
                            <input class="form-control @error('file') is-invalid @enderror" type="file" id="formFile"
                                name="file">
                            @error('file')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                            @enderror
                        </div>
                        <div class="col-sm-10">
                            <button type="submit" class="btn btn-primary mt-2">Import</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>
<script>
function sendForm() {
    document.getElementById("register-lecturer-form").submit();
}
</script>
@endsection