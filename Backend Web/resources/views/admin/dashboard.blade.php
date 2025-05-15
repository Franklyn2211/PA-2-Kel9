@extends('admin.layouts.app')

@section('title', 'Dashboard Admin Desa Digital')

@section('page-title', 'Overview')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <!-- Welcome Card -->
    <div class="row mb-4">
        <div class="col-12">
            <x-admin.welcome-card 
                title="Selamat Datang di Dashboard Desa Digital"
                subtitle="Pantau aktivitas desa dan kelola informasi penting untuk masyarakat Anda.">
                <button class="btn btn-light me-2 mb-2 mb-md-0">
                    <i class="fas fa-download me-2"></i> Unduh Laporan
                </button>
                <button class="btn" style="background: rgba(255,255,255,0.2); color: white;">
                    <i class="fas fa-calendar me-2"></i> {{ date('d F Y') }}
                </button>
            </x-admin.welcome-card>
        </div>
    </div>
    
    <!-- Quick Stats Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.1s">
            <x-admin.stat-card 
                icon="fa-users" 
                value="2,548" 
                label="Total Penduduk" 
                trend="2.3%" 
                trendIcon="fa-arrow-up" 
                trendClass="stat-trend-up" />
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.2s">
            <x-admin.stat-card 
                icon="fa-house-user" 
                value="682" 
                label="Jumlah KK" 
                trend="1.5%" 
                trendIcon="fa-arrow-up" 
                trendClass="stat-trend-up" />
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.3s">
            <x-admin.stat-card 
                icon="fa-file-alt" 
                value="24" 
                label="Surat Diproses" 
                trend="18 selesai" 
                trendIcon="fa-check-circle" 
                trendClass="stat-trend-up" />
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.4s">
            <x-admin.stat-card 
                icon="fa-calendar-check" 
                value="7" 
                label="Kegiatan Bulan Ini" 
                trend="2 berlangsung" 
                trendIcon="fa-clock" 
                trendClass="stat-trend-up" />
        </div>
    </div>
    
    <!-- Main Content Row -->
    <div class="row mb-4">
        <!-- Population Chart -->
        <div class="col-lg-8 mb-4">
            <div class="card h-100 animate-on-scroll slideInLeft">
                <div class="card-header">
                    <h6 class="mb-0">Statistik Penduduk</h6>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-soft-primary" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-ellipsis-h"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye"></i> Lihat Detail</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-download"></i> Unduh Data</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-print"></i> Cetak</a></li>
                        </ul>
                    </div>
                </div>
                <div class="card-body">
                    <div class="chart-wrapper">
                        <div class="chart-container">
                            <canvas id="populationChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Population Demographics -->
        <div class="col-lg-4 mb-4">
            <div class="card h-100 animate-on-scroll slideInRight">
                <div class="card-header">
                    <h6 class="mb-0">Demografi Penduduk</h6>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-soft-primary" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-ellipsis-h"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-filter"></i> Filter</a></li>
                        </ul>
                    </div>
                </div>
                <div class="card-body">
                    <div class="chart-wrapper">
                        <div class="population-chart-container mb-4">
                            <canvas id="demographicChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Laki-laki</span>
                            <span>52%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-primary" data-progress="52"></div>
                        </div>
                    </div>
                    
                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Perempuan</span>
                            <span>48%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-info" data-progress="48"></div>
                        </div>
                    </div>
                    
                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Anak-anak</span>
                            <span>18%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-success" data-progress="18"></div>
                        </div>
                    </div>
                    
                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Dewasa</span>
                            <span>65%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-warning" data-progress="65"></div>
                        </div>
                    </div>
                    
                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Lansia</span>
                            <span>17%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-danger" data-progress="17"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <!-- Document Requests Column -->
        <div class="col-lg-8 mb-4">
            <div class="card h-100 animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Permohonan Surat Terbaru</h6>
                    <a href="#" class="btn btn-sm btn-soft-primary">Lihat Semua</a>
                </div>
                <div class="card-body">
                    <x-admin.document-card 
                        title="Surat Keterangan Domisili"
                        user="Budi Santoso"
                        date="18 Juni 2023"
                        status="pending"
                        statusText="Dalam Proses" />
                    
                    <x-admin.document-card 
                        title="Surat Pengantar KTP"
                        user="Siti Rahma"
                        date="17 Juni 2023"
                        status="completed"
                        statusText="Selesai" />
                    
                    <x-admin.document-card 
                        title="Surat Keterangan Usaha"
                        user="Ahmad Fadli"
                        date="16 Juni 2023"
                        status="pending"
                        statusText="Dalam Proses" />
                    
                    <x-admin.document-card 
                        title="Surat Keterangan Miskin"
                        user="Dewi Lestari"
                        date="15 Juni 2023"
                        status="completed"
                        statusText="Selesai" />
                </div>
            </div>
        </div>
        
        <!-- Right Column -->
        <div class="col-lg-4">
            <!-- Upcoming Events -->
            <div class="card mb-4 animate-on-scroll slideInRight">
                <div class="card-header">
                    <h6 class="mb-0">Agenda Kegiatan</h6>
                    <a href="#" class="btn btn-sm btn-soft-primary">Kalender</a>
                </div>
                <div class="card-body">
                    <x-admin.event-card 
                        day="24"
                        month="Jun"
                        title="Rapat Koordinasi Desa"
                        time="09:00 - 12:00"
                        location="Balai Desa" />
                    
                    <x-admin.event-card 
                        day="26"
                        month="Jun"
                        title="Posyandu Bulanan"
                        time="08:00 - 11:00"
                        location="Pos Kesehatan" />
                    
                    <x-admin.event-card 
                        day="30"
                        month="Jun"
                        title="Pelatihan UMKM"
                        time="13:00 - 16:00"
                        location="Aula Balai Desa" />
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress bars
        setTimeout(() => {
            document.querySelectorAll('.animated-bar').forEach(bar => {
                const progress = bar.getAttribute('data-progress');
                bar.style.width = `${progress}%`;
            });
        }, 300);
        
        // Population Chart
        const populationCtx = document.getElementById('populationChart').getContext('2d');
        const populationChart = new Chart(populationCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'],
                datasets: [{
                    label: 'Jumlah Penduduk',
                    data: [2430, 2445, 2465, 2480, 2510, 2530, 2540, 2548, 2548, 2548, 2548, 2548],
                    backgroundColor: 'rgba(76, 223, 80, 0.1)',
                    borderColor: 'rgba(76, 223, 80, 0.8)',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: 'white',
                    pointBorderColor: 'rgba(76, 223, 80, 0.8)',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(255, 255, 255, 0.9)',
                        titleColor: '#2b2c34',
                        bodyColor: '#2b2c34',
                        borderColor: 'rgba(76, 223, 80, 0.1)',
                        borderWidth: 1,
                        padding: 12,
                        boxPadding: 6,
                        usePointStyle: true,
                        callbacks: {
                            label: function(context) {
                                return `Jumlah Penduduk: ${context.parsed.y} orang`;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false,
                            drawBorder: false
                        },
                        ticks: {
                            color: 'rgba(76, 223, 80, 0.7)'
                        }
                    },
                    y: {
                        grid: {
                            color: 'rgba(76, 223, 80, 0.05)',
                            drawBorder: false
                        },
                        ticks: {
                            color: 'rgba(76, 223, 80, 0.7)'
                        }
                    }
                }
            }
        });
        
        // Demographics Chart
        const demographicCtx = document.getElementById('demographicChart').getContext('2d');
        const demographicChart = new Chart(demographicCtx, {
            type: 'doughnut',
            data: {
                labels: ['Laki-laki', 'Perempuan'],
                datasets: [{
                    data: [52, 48],
                    backgroundColor: [
                        'rgba(76, 223, 80, 0.8)',
                        'rgba(0, 188, 212, 0.8)'
                    ],
                    borderWidth: 0,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle',
                            padding: 15,
                            font: {
                                size: 12
                            },
                            color: 'rgba(76, 223, 80, 0.8)'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'white',
                        titleColor: '#2b2c34',
                        bodyColor: '#2b2c34',
                        borderColor: 'rgba(76, 223, 80, 0.1)',
                        borderWidth: 1,
                        padding: 12,
                        cornerRadius: 12,
                        boxPadding: 6,
                        usePointStyle: true,
                        titleFont: {
                            size: 14,
                            weight: 600
                        },
                        bodyFont: {
                            size: 13
                        },
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.parsed}%`;
                            }
                        }
                    }
                }
            }
        });
    });
</script>
@endsection 