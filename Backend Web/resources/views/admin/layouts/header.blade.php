<header class="header">
    <div class="header-left">
        <button class="menu-toggle" id="menu-toggle">
            <i class="fas fa-bars"></i>
        </button>
        <h5 class="header-title mb-0 d-none d-md-block">@yield('page-title', 'Dashboard')</h5>
        <div class="search-form d-none d-md-block">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="search-input" placeholder="Cari sesuatu...">
        </div>
    </div>
    <div class="header-right">
        <button class="header-icon-btn" data-bs-toggle="dropdown" aria-expanded="false">
            <i class="fas fa-bell"></i>
            <span class="notification-badge">5</span>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><h6 class="dropdown-header">Notifikasi</h6></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-envelope"></i> Permohonan surat baru
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-exclamation-circle"></i> Laporan warga baru
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-calendar-day"></i> Acara desa minggu ini
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-sync"></i> Pembaruan data penduduk
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-users"></i> Rapat desa besok
                </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-center" href="#">Lihat semua</a></li>
            </ul>
        </button>
        <div class="user-dropdown" data-bs-toggle="dropdown" aria-expanded="false">
            <div class="user-avatar">
                AD
            </div>
            <div class="user-info">
                <div class="user-name">Admin Desa</div>
                <div class="user-role">Administrator</div>
            </div>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-user"></i> Profil
                </a></li>
                <li><a class="dropdown-item" href="#">
                    <i class="fas fa-cog"></i> Pengaturan
                </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item logout-item" href="#">
                    <i class="fas fa-sign-out-alt"></i> Keluar
                </a></li>
            </ul>
        </div>
    </div>
</header> 