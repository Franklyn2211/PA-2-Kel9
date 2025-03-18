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
                    <button class="btn btn-sm btn-soft-primary">
                        <i class="fas fa-plus me-1"></i> Tambah Berita
                    </button>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <img src="https://via.placeholder.com/500x300" class="card-img-top" alt="Pengumuman">
                                <div class="card-body">
                                    <span class="badge bg-warning mb-2">Pengumuman</span>
                                    <h5>Jadwal Vaksinasi Covid-19</h5>
                                    <p class="text-muted small mb-2">Dipublikasikan: 18 Juni 2023</p>
                                    <p class="mb-3">Berikut jadwal vaksinasi Covid-19 untuk warga desa yang akan dilaksanakan pada tanggal...</p>
                                    <div class="d-flex gap-2">
                                        <a href="#" class="btn btn-sm btn-soft-primary"><i class="fas fa-edit me-1"></i> Edit</a>
                                        <a href="#" class="btn btn-sm btn-soft-danger"><i class="fas fa-trash me-1"></i> Hapus</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4 mb-4">
                            <div class="card h-100">
                                <img src="https://via.placeholder.com/500x300" class="card-img-top" alt="Pengumuman">
                                <div class="card-body">
                                    <span class="badge bg-warning mb-2">Pengumuman</span>
                                    <h5>Jadwal Vaksinasi Covid-19</h5>
                                    <p class="text-muted small mb-2">Dipublikasikan: 18 Juni 2023</p>
                                    <p class="mb-3">Berikut jadwal vaksinasi Covid-19 untuk warga desa yang akan dilaksanakan pada tanggal...</p>
                                    <div class="d-flex gap-2">
                                        <a href="#" class="btn btn-sm btn-soft-primary"><i class="fas fa-edit me-1"></i> Edit</a>
                                        <a href="#" class="btn btn-sm btn-soft-danger"><i class="fas fa-trash me-1"></i> Hapus</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center mt-3">
                        <nav>
                            <ul class="pagination">
                                <li class="page-item disabled"><a class="page-link" href="#">Sebelumnya</a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#">Selanjutnya</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
