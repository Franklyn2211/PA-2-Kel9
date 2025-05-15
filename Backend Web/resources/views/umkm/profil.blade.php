@extends('umkm.layouts.app')

@section('title', 'Profil UMKM')

@section('page-title', 'Profil UMKM')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header text-center">
                    <h5 class="mb-0">Profil UMKM</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <!-- Nama UMKM -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nama UMKM</label>
                            <p class="form-control-plaintext">{{ auth()->user()->nama_umkm }}</p>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <p class="form-control-plaintext">{{ auth()->user()->email }}</p>
                        </div>

                        <!-- Nomor HP -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nomor HP</label>
                            <p class="form-control-plaintext">{{ auth()->user()->phone }}</p>
                        </div>

                        <!-- QRIS Image -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">QRIS DANA</label>
                            @if (auth()->user()->qris_image)
                            <small class="text-danger d-block mt-1">Pastikan QRIS berasal dari DANA</small>
                                <div class="mb-2">
                                    <img src="{{ asset('storage/' . auth()->user()->qris_image) }}" alt="QRIS Image" class="img-thumbnail" width="150">
                                </div>
                            @else
                            <small class="text-danger d-block mt-1">Pastikan QRIS berasal dari DANA</small>
                                <p class="text-muted">Belum ada QRIS yang diunggah.</p>
                                @endif
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="text-center mt-4">
                        <form action="{{ route('umkm.qris.update') }}" method="POST" enctype="multipart/form-data" style="display: inline;">
                            @csrf
                            @if (auth()->user()->qris_image)
                                <label for="qris_image" class="btn btn-soft-primary me-2">
                                    <i class="fas fa-upload"></i> Ubah QRIS
                                </label>
                            @else
                                <label for="qris_image" class="btn btn-soft-primary me-2">
                                    <i class="fas fa-upload"></i> Tambah QRIS
                                </label>
                            @endif
                            <input type="file" name="qris_image" id="qris_image" class="d-none" onchange="this.form.submit()">
                        </form>
                        <a href="{{ route('umkm.profil.edit') }}" class="btn btn-soft-secondary me-2">
                            <i class="fas fa-edit"></i> Edit Profil
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
