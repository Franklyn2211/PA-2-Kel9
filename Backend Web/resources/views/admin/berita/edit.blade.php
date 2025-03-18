@extends('admin.layouts.app')

@section('title', 'Edit Berita - Admin Desa Digital')

@section('page-title', 'Edit Berita')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.berita.update', $news->id)}}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                        <!-- Judul -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Judul</label>
                            <input type="text" name="title" id="title" class="form-control" value="{{ old('title', $news->title) }}" required>
                        </div>

                        <!-- Deskripsi -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea name="description" id="summernote" required>{{ old('description', $news->description) }}</textarea>
                        </div>

                        <!-- Gambar -->
                        <div class="mb-3">
                            <label for="gambar" class="form-label">Gambar</label>
                            @if ($news->photo)
                                <div class="mb-2">
                                    <img src="{{ asset('storage/' . $news->photo) }}" alt="Foto Berita" width="150">
                                </div>
                            @endif
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*">
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Simpan Perubahan</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
