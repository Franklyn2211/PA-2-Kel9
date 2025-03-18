@extends('admin.layouts.app')

@section('title', 'Layanan - Admin Desa Ambarita')

@section('page-title', 'Layanan')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Layanan Desa</h6>
                    <a href="{{ route('admin.layanan.create') }}">
                        <button class="btn btn-sm btn-soft-primary">
                            <i class="fas fa-plus me-1"></i> Tambah Produk
                        </button>
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Foto</th>
                                    <th>Nama Produk</th>
                                    <th>Deskripsi</th>
                                    <th>Harga</th>
                                    <th>Stok</th>
                                    <th>Nomor HP</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($products as $key => $product)
                                <tr>
                                    <td>{{ $key + 1 }}</td>
                                    <td>
                                        @if ($product->photo)
                                            <img src="{{ asset('storage/' . $product->photo) }}" alt="{{ $product->product_name }}" width="50" height="50" style="object-fit: cover; border-radius: 8px;">
                                        @else
                                            <span class="badge bg-secondary">Tidak ada foto</span>
                                        @endif
                                    </td>
                                    <td>{{ $product->product_name }}</td>
                                    <td>{!! $product->description !!}</td>
                                    <td>Rp{{ number_format($product->price, 2, ',', '.') }}</td>
                                    <td>{{ $product->stock }}</td>
                                    <td>{{ $product->phone }}</td>
                                    <td>
                                        <a href="{{ route('admin.layanan.edit', $product->id) }}" class="btn btn-sm btn-soft-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('admin.layanan.destroy', $product->id) }}" method="POST" style="display:inline;">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-soft-danger" onclick="return confirm('Yakin ingin menghapus?')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                @endforeach
                                @if ($products->isEmpty())
                                <tr>
                                    <td colspan="6" class="text-center">Tidak ada data produk</td>
                                </tr>
                                @endif
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        {{ $products->links('pagination::bootstrap-4') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
