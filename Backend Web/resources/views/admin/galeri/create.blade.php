@extends('admin.layouts.app')

@section('title', 'Tambah Galeri - Admin Desa Digital')

@section('page-title', 'Tambah Galeri')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.galeri.store')}}" method="POST" enctype="multipart/form-data">
                    @csrf
                        <!-- Judul -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Judul</label>
                            <input type="text" name="title" id="title" class="form-control" required>
                        </div>

                        <!-- Gambar -->
                        <div class="mb-3">
                            <label for="gambar" class="form-label">Gambar</label>
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*" required>
                        </div>

                        <!-- Tanggal Diambil -->
                        <div class="mb-3">
                            <label for="date_taken" class="form-label">Tanggal Diambil</label>
                            <input type="date" name="date_taken" id="date_taken" class="form-control" required>
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Tambah Galeri</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
