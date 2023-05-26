@extends('layouts.app')
@section('title','Students')
@section('content')

@if (session('info'))
<div id="success-message" class="alert alert-success  fade show" role="alert">
    <strong>{{ session('info') }}</strong>
</div>
@endif

@if (session('error'))
<div id="success-message" class="alert alert-danger" role="alert">
    <strong>{{ session('error') }}</strong>
</div>
@endif
<div class="container bg-white ">
    <div class="row mt-3 align-items-baseline">
        <div class="col-md-3 col-sm-3">
            <a href="{{route('create.student')}}" class='btn btn-success'>
                <i class="fa fa-plus"></i> New
            </a>
        </div>

        <div class="col-md-3  col-sm-3 mt-2">
            <h2>Students</h2>
        </div>

        <div class="col-md-6 col-sm-6">
            <form class="d-flex" action="{{ route('search.student') }}" method="GET">
                <input class="form-control me-2" name="search" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Search</button>
            </form>
        </div>
    </div>

    <div class="row mt-3">
        @if ($students->isEmpty())
        <div class="alert alert-info">
            No records found. <a class="ms-2"
                href="{{route('register.student')}}">{{request()->routeIs('register.student')?'':'Go back'}}</a> <a
                class="ms-2" href="{{route('dashboard')}}">Go To Dashboard</a>
        </div>
        @else
        <table id="example1" class="table table-striped table-hover">
            <thead>
                <th>Registration Number</th>
                <th>Firstname</th>
                <th>Lastname</th>
                <th>Email</th>
                <th>Actions</th>
            </thead>
            <tbody>
                @foreach($students as $student)
                <tr>
                    <td>{{ $student->username }}</td>
                    <td>{{$student->firstName}}</td>
                    <td>{{$student->lastName}}</td>
                    <td>{{$student->email}}</td>
                    <td>
                        <a href="{{ route('edit.student', str_replace('/', '-', $student->username)) }}"
                            class='btn btn-success btn-sm me-2 edit btn-flat'>
                            <i class='fa fa-edit'></i> Edit
                        </a>

                        <button class='btn btn-danger btn-sm  delete btn-flat' data-bs-toggle="modal"
                            data-bs-target="#delete" data-username="{{str_replace('/','-',$student->username)}}"
                            data-firstname="{{$student->firstName}}" data-lastname="{{$student->lastName}}">
                            <i class='fa fa-trash'></i> Delete
                        </button>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>
        @endif
        {{ $students->links('layouts.paginationlinks') }}
    </div>

    <!--delete student Modal -->
    <div class="modal fade" id="delete" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
        aria-labelledby="deleteLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Are you sure you want to delete?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Do you really want to delete <strong><span id="delete-student-name"></span></strong>?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm btn-flat"
                        data-bs-dismiss="modal">Cancel</button>
                    <form id="delete-student-form" method="POST"
                        action="{{ route('destroy.student', ['username' => '__username__']) }}">
                        @csrf
                        @method('DELETE')
                        <button class='btn btn-danger btn-sm delete btn-flat' type="submit"
                            data-bs-dismiss="modal">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
    const deleteButtons = document.querySelectorAll('.delete');

    deleteButtons.forEach(button => {
        button.addEventListener('click', () => {
            const username = button.getAttribute('data-username');
            const firstname = button.getAttribute('data-firstName');
            const lastname = button.getAttribute('data-lastName');
            const deleteStudentForm = document.querySelector('#delete-student-form');
            const deleteStudentName = document.querySelector('#delete-student-name');
            const deleteStudentAction = deleteStudentForm.getAttribute('action').replace(
                '__username__', username);
            deleteStudentForm.setAttribute('action', deleteStudentAction);
            deleteStudentName.textContent = `${firstname} ${lastname}`;

        });
    });
    </script>


    @endsection