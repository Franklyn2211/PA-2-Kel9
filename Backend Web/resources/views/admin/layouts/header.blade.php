<header class="header">
    <div class="header-left">
        <button class="menu-toggle" id="menu-toggle">
            <i class="fas fa-bars"></i>
        </button>
        <h5 class="header-title mb-0 d-none d-md-block">@yield('page-title', 'Dashboard')</h5>
    </div>
    <div class="header-right">

        <!-- Dropdown Admin -->
        <div class="dropdown">
            <button class="btn user-dropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="user-avatar">
                    AD
                </div>
                <div class="user-info">
                    <div class="user-name">Admin Desa</div>
                    <div class="user-role">Administrator</div>
                </div>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-user"></i> Profil
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-cog"></i> Pengaturan
                </a></li>
                <li><hr class="dropdown-divider"></li>
            <li>
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="dropdown-item logout-item">
                    <i class="fas fa-sign-out-alt"></i> Keluar
                </button>
            </form>
        </li>
            </ul>
        </div>
    </div>
</header>
