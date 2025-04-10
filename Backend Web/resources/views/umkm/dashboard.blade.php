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
                trend="2.3%"
                trendIcon="fa-arrow-up"
                trendClass="stat-trend-up" />
        </div>
    </div>
</div>
@endsection
