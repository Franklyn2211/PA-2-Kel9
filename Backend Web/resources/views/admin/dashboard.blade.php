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
                value="{{ $totalPenduduk }}"
                label="Total Penduduk" />
        </div>

        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.2s">
            <x-admin.stat-card
                icon="fa-user-plus"
                value="{{ $pendudukBaru }}"
                label="Penduduk Baru Bulan Ini" />
        </div>

        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.3s">
            <x-admin.stat-card
                icon="fa-file-alt"
                value="{{ $totalPengajuan }}"
                label="Banyak Pengajuan Surat"
                {{-- trend="{{ $suratSelesai }} selesai" --}}
                trendIcon="fa-check-circle"
                trendClass="stat-trend-up" />
        </div>

        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.4s">
            <x-admin.stat-card
                icon="fa-calendar-check"
                value="{{ $diAjukan }}"
                label="Surat yang belum diproses"
                {{-- trend="{{ $kegiatanBerlangsung }} berlangsung" --}}
                trendIcon="fa-clock"
                trendClass="stat-trend-up" />
        </div>
    </div>

    <!-- Main Content Row -->
    <div class="row mb-4">
        <!-- Document Requests Column -->
        <div class="col-lg-8 mb-4">
            <div class="card h-100 animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Permohonan Surat Terbaru</h6>
                    <a href="{{ route('admin.pengajuan.index') }}" class="btn btn-sm btn-soft-primary">Lihat Semua</a>
                </div>
                <div class="card-body">
                    @forelse ($recentPengajuan as $pengajuan)
                        <x-admin.document-card
                            title="{{ $pengajuan->template->jenis_surat ?? 'Jenis Surat Tidak Diketahui' }}"
                            user="{{ $pengajuan->resident->name ?? 'Nama Tidak Diketahui' }}"
                            date="{{ $pengajuan->created_at->format('d F Y') }}"
                            status="{{ $pengajuan->status }}"
                            statusText="{{ ucfirst($pengajuan->status) }}" />
                    @empty
                        <p class="text-muted">Tidak ada permohonan surat terbaru.</p>
                    @endforelse
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
                            <span>{{ $demografi['lakiLaki'] }}%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-primary" data-progress="{{ $demografi['lakiLaki'] }}"></div>
                        </div>
                    </div>

                    <div class="demographic-row">
                        <div class="demographic-label">
                            <span>Perempuan</span>
                            <span>{{ $demografi['perempuan'] }}%</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar animated-bar bg-info" data-progress="{{ $demografi['perempuan'] }}"></div>
                        </div>
                    </div>
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

        // Demographics Chart
        const demographicCanvas = document.getElementById('demographicChart');
        if (demographicCanvas) {
            const demographicCtx = demographicCanvas.getContext('2d');
            const demographicData = [{{ $demografi['lakiLaki'] ?? 50 }}, {{ $demografi['perempuan'] ?? 50 }}];

            new Chart(demographicCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Laki-laki', 'Perempuan'],
                    datasets: [{
                        data: demographicData,
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
        } else {
            console.error('Demographic chart canvas not found. Ensure the canvas ID is "demographicChart".');
        }
    });
</script>
@endsection
