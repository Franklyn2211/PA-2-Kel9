@extends('admin.layouts.app')

@section('title', 'Tambah Template Surat')
@section('page-title', 'Tambah Template Surat')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.templates.store') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <!-- Jenis Surat -->
                        <div class="mb-3">
                            <label for="jenis_surat" class="form-label">Jenis Surat</label>
                            <select id="jenis_surat" name="jenis_surat" class="form-select" required>
                                <option value="" disabled selected>Pilih Jenis Surat</option>
                                <option value="Surat Belum Menikah">Surat Belum Menikah</option>
                                <option value="Surat Domisili">Surat Domisili</option>
                            </select>
                        </div>

                        <!-- Nama Surat -->
                        <div class="mb-3">
                            <label for="nama_surat" class="form-label">Nama Surat</label>
                            <input type="text" name="nama_surat" id="nama_surat" class="form-control" placeholder="Masukkan nama surat" required>
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Simpan</button>
                        <a href="{{ route('admin.templates.index') }}" class="btn btn-secondary">Batal</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
