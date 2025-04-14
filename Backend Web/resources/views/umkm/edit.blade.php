@extends('umkm.layouts.app')

@section('title', 'Edit Profil UMKM')

@section('page-title', 'Edit Profil UMKM')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header text-center">
                    <h5 class="mb-0">Edit Profil UMKM</h5>
                </div>
                <div class="card-body">
                    <form action="{{ route('umkm.profil.update') }}" method="POST">
                        @csrf
                        @method('PUT')

                        <!-- Nama UMKM -->
                        <div class="mb-3">
                            <label for="nama_umkm" class="form-label">Nama UMKM</label>
                            <input type="text" name="nama_umkm" id="nama_umkm" class="form-control" value="{{ old('nama_umkm', $umkm->nama_umkm) }}" required>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" name="email" id="email" class="form-control" value="{{ old('email', $umkm->email) }}" required>
                        </div>

                        <!-- Nomor HP -->
                        <div class="mb-3">
                            <label for="phone" class="form-label">Nomor HP</label>
                            <div class="input-group">
                                <span class="input-group-text">+62</span>
                            <input type="text" name="phone" id="phone" class="form-control" value="{{ old('phone', ltrim($umkm->phone, '+62')) }}" required>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="text-center">
                            <button type="submit" class="btn btn-soft-primary">
                                <i class="fas fa-save"></i> Simpan Perubahan
                            </button>
                            <a href="{{ route('umkm.profil') }}" class="btn btn-danger">
                                <i class="fas fa-times"></i> Batal
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
