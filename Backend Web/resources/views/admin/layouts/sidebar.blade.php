<aside class="sidebar">
    <div class="sidebar-header">
        <a href="/admin/dashboard" class="sidebar-logo">
            <div class="sidebar-logo-icon">
                <img src="{{ asset('assets/images/logo.png') }}" alt="Desa Digital Logo">
            </div>
            <div class="sidebar-logo-text">
                <div class="sidebar-logo-title">Desa Ambarita</div>
                <div class="sidebar-logo-subtitle">Admin Panel</div>
            </div>
        </a>
    </div>
    <div class="sidebar-body">
        <div class="nav-section">Dashboard</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/dashboard') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/dashboard">
                    <i class="fas fa-chart-line"></i>
                    <span class="nav-text">Overview</span>
                </a>
            </li>
        </ul>

        <div class="nav-section">Manajemen</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/penduduk*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/penduduk">
                    <i class="fas fa-users"></i>
                    <span class="nav-text">Data Penduduk</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/layanan*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('admin.layanan.index')}}">
                    <i class="fas fa-hands-helping"></i>
                    <span class="nav-text">Layanan</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/berita*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('admin.berita.index')}}">
                    <i class="fas fa-newspaper"></i>
                    <span class="nav-text">Berita</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/pengumuman*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/pengumuman">
                    <i class="fas fa-bullhorn"></i>
                    <span class="nav-text">Pengumuman</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/galeri*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/galeri">
                    <i class="fas fa-images"></i>
                    <span class="nav-text">Galeri</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/surat*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/surat">
                    <i class="fas fa-file-alt"></i>
                    <span class="nav-text">Surat Menyurat</span>
                </a>
            </li>
        </ul>

        <div class="nav-section">Master Data</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/aparatur*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/aparatur">
                    <i class="fas fa-user-tie"></i>
                    <span class="nav-text">Aparatur Desa</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/program*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/program">
                    <i class="fas fa-tasks"></i>
                    <span class="nav-text">Program Desa</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/pembangunan*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/pembangunan">
                    <i class="fas fa-hard-hat"></i>
                    <span class="nav-text">Pembangunan</span>
                </a>
            </li>
        </ul>

        <div class="nav-section">Sistem</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/profil*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/profil">
                    <i class="fas fa-info-circle"></i>
                    <span class="nav-text">Profil Desa</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/users*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/users">
                    <i class="fas fa-user-shield"></i>
                    <span class="nav-text">Pengguna</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/settings*') ? 'active' : '' }}">
                <a class="nav-link" href="/admin/settings">
                    <i class="fas fa-sliders-h"></i>
                    <span class="nav-text">Pengaturan</span>
                </a>
            </li>
        </ul>
    </div>
</aside>
