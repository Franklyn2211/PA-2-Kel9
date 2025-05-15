@extends('admin.layouts.app')

@section('title', 'Profil Desa - Admin Desa Ambarita')

@section('page-title', 'Profil Desa')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h6 class="mb-0">@yield('page-title')</h6>
                    <div class="d-flex gap-2">
                        @if(!$profilDesaExists)
                            <a href="{{ route('admin.profildesa.create') }}" class="btn btn-sm btn-soft-primary">
                                <i class="fas fa-plus me-1"></i> Tambah Profil Desa
                            </a>
                        @else
                            <a href="{{ route('admin.profildesa.edit', $profilDesa->id) }}" class="btn btn-sm btn-soft-primary">
                                <i class="fas fa-edit me-1"></i> Edit
                            </a>
                            <form action="{{ route('admin.profildesa.destroy', $profilDesa->id) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-soft-danger">
                                    <i class="fas fa-trash me-1"></i> Hapus
                                </button>
                            </form>
                        @endif
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        @if ($profilDesaExists)
                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <span class="badge bg-success mb-2">Sejarah</span>
                                    <p class="text-muted small mb-2">{{ $profilDesa->created_at->format('d F Y') }}</p>
                                    <p class="mb-3">{!! $profilDesa->history !!}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <span class="badge bg-warning mb-2">Visi</span>
                                    <p class="text-muted small mb-2">{{ $profilDesa->created_at->format('d F Y') }}</p>
                                    <p class="mb-3">{!! $profilDesa->visi !!}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <span class="badge bg-warning mb-2">Misi</span>
                                    <p class="text-muted small mb-2">{{ $profilDesa->created_at->format('d F Y') }}</p>
                                    <p class="mb-3">{!! $profilDesa->misi !!}</p>
                                </div>
                            </div>
                        </div>
                        @else
                        <div class="col-12">
                            <p class="text-muted text-center">Belum ada profil desa yang tersedia. Silakan tambah profil desa.</p>
                        </div>
                        @endif
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
