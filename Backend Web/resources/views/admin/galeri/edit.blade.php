@extends('admin.layouts.app')

@section('title', 'Edit Gambar - Admin Desa Digital')

@section('page-title', 'Edit Gambar')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.galeri.update', $galleries->id)}}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                        <!-- Judul -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Judul</label>
                            <input type="text" name="title" id="title" class="form-control" value="{{old('title', $galleries->title)}}" required>
                        </div>

                        <!-- Gambar -->
                        <div class="mb-3">
                            <label for="gambar" class="form-label">Gambar</label>
                            @if ($galleries->photo)
                                <div class="mb-2">
                                    <img src="{{ asset('storage/' . $galleries->photo) }}" alt="Foto" width="150">
                                </div>
                            @endif
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*">
                            <small class="text-muted">Gambar harus berformat JPG, PNG, atau JPEG dan maksimal 5MB.</small>
                            @error('photo')
                                <div class="text-danger">{{ $message }}</div>
                            @enderror
                        </div>


                        <!-- Tanggal Diambil -->
                        <div class="mb-3">
                            <label for="date_taken" class="form-label">Tanggal Diambil</label>
                            <input type="date" name="date_taken" id="date_taken" class="form-control" value="{{old('date_taken', $galleries->date_taken)}}" required>
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
