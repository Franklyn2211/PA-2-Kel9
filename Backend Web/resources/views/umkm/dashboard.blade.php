@extends('umkm.layouts.app')

@section('title', 'Dashboard Umkm Desa')

@section('page-title', 'Overview')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <!-- Welcome Card -->
    <div class="row mb-4">
        <div class="col-12">
            <x-admin.welcome-card
                title="Selamat Datang, {{ auth()->user()->nama_umkm }}"
                subtitle="Kelola produk UMKM Anda dan tingkatkan penjualan dengan mudah.">
                <a href="{{ route('umkm.products.create') }}" class="btn btn-light me-2 mb-2 mb-md-0">
                    <i class="fas fa-plus me-2"></i> Tambah Produk
                </a>
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
                icon="fa-box"
                value="{{ auth()->user()->products()->count() }}"
                label="Total Produk"
                />
        </div>
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.2s">
            <x-admin.stat-card
                icon="fa-clock"
                value="{{ $pesananBelumDiterima }}"
                label="Pesanan Belum Diterima"
                />
        </div>
        <div class="col-xl-3 col-md-6 mb-4 animate-on-scroll slideInUp" style="animation-delay: 0.3s">
            <x-admin.stat-card
                icon="fa-check-circle"
                value="{{ $pesananSudahDiterima }}"
                label="Pesanan Sudah Diterima"
                 />
        </div>
    </div>

    <!-- Chart Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">Statistik Pesanan Per Bulan</h5>
                </div>
                <div class="card-body">
                    <div class="chart-wrapper">
                        <div class="chart-container">
                            <canvas id="orderChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('orderChart').getContext('2d');
        const orderChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: {!! json_encode($months) !!}, // Array of month names
                datasets: [{
                    label: 'Jumlah Pesanan',
                    data: {!! json_encode($ordersPerMonth) !!}, // Array of order counts per month
                    backgroundColor: 'rgba(76, 223, 80, 0.1)',
                    borderColor: 'rgba(76, 223, 80, 0.8)',
                    borderWidth: 2,
                    tension: 0.4, // Smooth curve
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
                                return `Jumlah Pesanan: ${context.parsed.y}`;
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
    });
</script>
@endsection
