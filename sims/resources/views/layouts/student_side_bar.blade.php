<div class="container-fluid">
    <div class="row flex-nowrap">
        <div class="col-auto col-md-3 col-xl-2 px-sm-2 px-0 bg-dark shadow-md">
            <div class="d-flex flex-column pt-2 text-white" style="min-height:90vh;">
                <ul class="nav nav-pills  nav-sidebar flex-column" id="menu">
                    <li class="nav-item">
                        <a href="{{route('dashboard')}}"
                            class="nav-link d-block  align-middle ps-2 pe-4 {{request()->routeIs('dashboard')? 'active': ''}} ">
                            <i class="fa-solid fa-sharp fa-gauge text-white"></i>
                            <span class="ms-1 d-none d-sm-inline text-white">Dashboard</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="{{route('social.student')}}"
                            class="nav-link d-block  align-middle ps-2 {{request()->routeIs('social.student')? 'active': ''}} ">
                            <i class=" fa-solid fa-coins text-white"></i>
                            <span class="ms-1 d-none d-sm-inline text-white">Social Token</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="{{route('profile')}}"
                            class="nav-link d-block  align-middle ps-2 {{request()->routeIs('profile')? 'active': ''}} ">
                            <i class="fa-solid fa-sharp fa-user text-white"></i>
                            <span class="ms-1 d-none d-sm-inline text-white">My Profile</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="{{route('password.edit')}}"
                            class="nav-link ps-2 align-middle {{request()->routeIs('password.edit')? 'active': ''}} ">
                            <i class="fa-solid text-white fa-lock"></i>
                            <span class="ms-1 d-none d-sm-inline text-white">Password</span> </a>
                    </li>

                </ul>
            </div>
        </div>
        <div class="col py-3">
            @yield('content')
        </div>
    </div>
</div>