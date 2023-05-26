@extends('layouts.app')
@section('title','Edit lecturer')
@section('content')
<div class="container bg-white justify-content-center">
    <h5 class="mb-2" id="registerLabel">Edit Lecturer</h5>
    <hr>
    <form action="{{route('update.lecturer',str_replace('/','-',$lecturer->username))}}" id="edit-lecturer-form"
        method="POST">
        @csrf
        @method('PUT')
        <div class="row mb-3">
            <label for="username" class="col col-form-label form-label">{{__('Registration Number')}}</label>
            <div class="col-8">
                <input id="username" type="text" readonly class="form-control @error('username') is-invalid @enderror"
                    value="{{ old('username',$lecturer->username) }}" name="username" autocomplete="username">
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
                    value="{{ old('firstName',$lecturer->firstName) }}" name="firstName" autocomplete="firstName">
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
                    value="{{ old('lastName',$lecturer->lastName) }}" name="lastName" autocomplete="lastName">
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
                    value="{{ old('email',$lecturer->email) }}" autocomplete="email">
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
            <button type="button" class="btn btn-success btn-sm btn-flat" onclick="submitForm()">Update</button>
        </div>
    </div>
</div>

<script>
function submitForm() {
    document.getElementById("edit-lecturer-form").submit();
}
</script>
@endsection