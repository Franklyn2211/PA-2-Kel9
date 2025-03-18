@extends('admin.layouts.app')

@section('title', 'Edit Produk - Admin Desa Digital')

@section('page-title', 'Edit Produk')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.layanan.update', $products->id) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <!-- Nama Produk -->
                        <div class="mb-3">
                            <label for="product_name" class="form-label">Nama Produk</label>
                            <input type="text" name="product_name" id="product_name" class="form-control" value="{{ old('product_name', $products->product_name) }}" required>
                        </div>

                        <!-- Deskripsi -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea name="description" id="summernote" required>{{ old('description', $products->description) }}</textarea>
                        </div>

                        <!-- Gambar -->
                        <div class="mb-3">
                            <label for="photo" class="form-label">Gambar</label>
                            @if ($products->photo)
                                <div class="mb-2">
                                    <img src="{{ asset('storage/' . $products->photo) }}" alt="Foto Produk" width="150">
                                </div>
                            @endif
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*">
                        </div>

                        <!-- Lokasi -->
                        <div class="mb-3">
                            <label for="location" class="form-label">Lokasi</label>
                            <input type="text" name="location" id="location" class="form-control" value="{{ old('location', $products->location) }}" required>
                        </div>

                        <!-- Harga -->
                        <div class="mb-3">
                            <label for="price" class="form-label">Harga</label>
                            <input type="number" name="price" id="price" class="form-control" value="{{ old('price', $products->price) }}" required>
                        </div>

                        <!-- Stok -->
                        <div class="mb-3">
                            <label for="stock" class="form-label">Stok</label>
                            <input type="number" name="stock" id="stock" class="form-control" value="{{ old('stock', $products->stock) }}" required>
                        </div>

                        <!-- Nomor hp -->
                        <div class="mb-3">
                            <label for="phone" class="form-label">Nomor HP</label>
                            <input type="text" name="phone" id="phone" class="form-control" value="{{ old('phone', $products->phone) }}" required>
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
