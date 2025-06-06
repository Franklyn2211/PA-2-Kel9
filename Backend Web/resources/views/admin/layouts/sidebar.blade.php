<aside class="sidebar">
    <div class="sidebar-header">
        <a href="/admin/dashboard" class="sidebar-logo">
            <div class="sidebar-logo-icon">
                <img src="{{ asset('assets/images/logo.bmp') }}" alt="Desa Digital Logo">
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
                <a class="nav-link" href="{{route('admin.galeri.index')}}">
                    <i class="fas fa-images"></i>
                    <span class="nav-text">Galeri</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/pengajuan*') ? 'active' : '' }}">
                <a class="nav-link {{ request()->is('admin/templates*') || request()->is('admin/admin/pengajuan*') ? 'active' : '' }}"
                   data-bs-toggle="collapse" href="#suratMenu" role="button" aria-expanded="false" aria-controls="suratMenu">
                    <i class="fas fa-file-alt"></i>
                    <span class="nav-text">Surat Menyurat</span>
                </a>
                <div class="collapse {{ request()->is('admin/templates*') || request()->is('admin/admin/pengajuan*') ? 'show' : '' }}" id="suratMenu">
                    <ul class="nav flex-column" style="padding-left: 1.5rem;">
                        <li class="nav-item {{ request()->is('admin/templates*') ? 'active' : '' }}">
                            <a class="nav-link" href="{{route('admin.templates.index')}}" style="font-size: 0.85rem;">
                                <i class="fas fa-file"></i>
                                <span class="nav-text">Template Surat</span>
                            </a>
                        </li>
                        <li class="nav-item {{ request()->is('admin/pengajuan*') ? 'active' : '' }}">
                            <a class="nav-link" href="{{route('admin.pengajuan.index')}}" style="font-size: 0.85rem;">
                                <i class="fas fa-envelope"></i>
                                <span class="nav-text">Pengajuan Surat</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>

        <div class="nav-section">Master Data</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/staff*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('admin.staff.index')}}">
                    <i class="fas fa-user-tie"></i>
                    <span class="nav-text">Staff Desa</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('admin/umkm*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('admin.umkm.index')}}">
                    <i class="fas fa-store"></i>
                    <span class="nav-text">UMKM</span>
                </a>
            </li>
        </ul>

        <div class="nav-section">Sistem</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('admin/profil*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('admin.profildesa.index')}}">
                    <i class="fas fa-info-circle"></i>
                    <span class="nav-text">Profil Desa</span>
                </a>
            </li>
        </ul>
    </div>
</aside>
