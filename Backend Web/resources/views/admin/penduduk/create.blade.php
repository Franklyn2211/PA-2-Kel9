@extends('admin.layouts.app')

@section('title', 'Tambah Data - Admin Desa Ambarita')

@section('page-title', 'Tambah Data')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.penduduk.store') }}" method="POST">
                        @csrf

                        <!-- NIK -->
                        <div class="mb-3">
                            <label for="nik" class="form-label">NIK</label>
                            <input type="text" name="nik" id="nik" class="form-control" maxlength="16" required>
                        </div>

                        <!-- Nama Lengkap -->
                        <div class="mb-3">
                            <label for="name" class="form-label">Nama Lengkap</label>
                            <input type="text" name="name" id="name" class="form-control" required>
                        </div>

                        <!-- Jenis Kelamin -->
                        <div class="mb-3">
                            <label for="gender" class="form-label">Jenis Kelamin</label>
                            <select name="gender" id="gender" class="form-control" required>
                                <option value="" disabled selected>Pilih Jenis Kelamin</option>
                                <option value="Male">Laki-laki</option>
                                <option value="Female">Perempuan</option>
                            </select>
                        </div>

                        <!-- Tempat Tinggal -->
                        <div class="mb-3">
                            <label for="address" class="form-label">Alamat</label>
                            <input type="text" name="address" id="address" class="form-control" required>
                        </div>

                        <!-- Tanggal Lahir -->
                        <div class="mb-3">
                            <label for="birth_date" class="form-label">Tanggal Lahir</label>
                            <input type="date" name="birth_date" id="birth_date" class="form-control" required>
                        </div>

                        <!-- Agama -->
                        <div class="mb-3">
                            <label for="religion" class="form-label">Agama</label>
                            <input type="text" name="religion" id="religion" class="form-control" required>
                        </div>

                        <!-- Nomor Kartu Keluarga -->
                        <div class="mb-3">
                            <label for="family_card_number" class="form-label">Nomor KK</label>
                            <input type="text" name="family_card_number" id="family_card_number" class="form-control" maxlength="16" required>
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Tambah Data</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
