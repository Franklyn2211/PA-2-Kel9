@extends('admin.layouts.app')

@section('content')
<div class="container">
    <h1>Tambah Template Surat</h1>
    <form action="{{ route('templates.store') }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="mb-3">
            <label for="jenis_surat" class="form-label">Jenis Surat</label>
            <input type="text" name="jenis_surat" id="jenis_surat" class="form-control" required>
        </div>
        <div class="mb-3">
            <label for="nama_surat" class="form-label">Nama Surat</label>
            <input type="text" name="nama_surat" id="nama_surat" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-success">Simpan</button>
    </form>
</div>
@endsection
