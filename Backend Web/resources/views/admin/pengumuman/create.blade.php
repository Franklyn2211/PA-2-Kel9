@extends('admin.layouts.app')

@section('title', 'Tambah Pengumuman - Admin Desa Digital')

@section('page-title', 'Tambah Pengumuman')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.pengumuman.store')}}" method="POST" enctype="multipart/form-data">
                    @csrf
                        <!-- Judul -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Judul</label>
                            <input type="text" name="title" id="title" class="form-control" required>
                        </div>

                        <!-- Deskripsi -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea name="description" id="summernote" required></textarea>
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Tambah Pengumuman</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
