<aside class="sidebar">
    <div class="sidebar-header">
        <a href="{{ route('umkm.dashboard') }}" class="sidebar-logo">
            <div class="sidebar-logo-icon">
                <img src="{{ asset('assets/images/logo.bmp') }}" alt="Desa Digital Logo">
            </div>
            <div class="sidebar-logo-text">
                <div class="sidebar-logo-title">Desa Ambarita</div>
                <div class="sidebar-logo-subtitle">UMKM</div>
            </div>
        </a>
    </div>
    <div class="sidebar-body">
        <div class="nav-section">Dashboard</div>
        <ul class="nav flex-column">
            <li class="nav-item {{ request()->is('umkm') ? 'active' : '' }}">
                <a class="nav-link" href="{{ route('umkm.dashboard') }}">
                    <i class="fas fa-chart-line"></i>
                    <span class="nav-text">Overview</span>
                </a>
            </li>
            <li class="nav-item {{ request()->is('umkm/products*') ? 'active' : '' }}">
                <a class="nav-link" href="{{route('umkm.products.index')}}">
                    <i class="fas fa-store"></i>
                    <span class="nav-text">Daftar Produk</span>
                </a>
            </li>
        </ul>
    </div>
</aside>
