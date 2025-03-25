@extends('admin.layouts.app')

@section('title', 'Pengumuman - Admin Desa Ambarita')

@section('page-title', 'Pengumuman')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                    <a href="{{ route('admin.pengumuman.create') }}">
                    <button class="btn btn-sm btn-soft-primary">
                        <i class="fas fa-plus me-1"></i> Tambah Berita
                    </button>
                </a>
                </div>
                <div class="card-body">
                    <div class="row">
                        @foreach ($announcements as $key => $item)
                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <span class="badge bg-warning mb-2">Pengumuman</span>
                                    <h5>{{ $item->title }}</h5>
                                    <p class="text-muted small mb-2">{{ $item->created_at->format('d F Y') }}</p>
                                    <p class="mb-3">{!! $item->description !!}</p>
                                    <div class="d-flex gap-2">
                                        <a href="{{ route('admin.pengumuman.edit', $item->id) }}" class="btn btn-sm btn-soft-primary"><i class="fas fa-edit me-1"></i> Edit</a>
                                        <form action="{{ route('admin.pengumuman.destroy', $item->id) }}" method="POST" style="display:inline;">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-soft-danger" onclick="return confirm('Yakin ingin menghapus?')">
                                            <i class="fas fa-trash me-1"></i> Hapus</form>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        @endforeach
                    </div>

                    <div class="d-flex justify-content-center mt-3">
                        {{ $announcements->links('pagination::bootstrap-4') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
