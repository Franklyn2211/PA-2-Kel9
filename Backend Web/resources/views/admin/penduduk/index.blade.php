@extends('admin.layouts.app')

@section('title', 'Data Penduduk - Admin Desa Digital')

@section('page-title', 'Data Penduduk')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Data Penduduk</h6>
                    <a href="{{ route('admin.penduduk.create') }}">
                        <button class="btn btn-sm btn-soft-primary">
                            <i class="fas fa-plus me-1"></i> Tambah Data
                        </button>
                    </a>
                </div>
                <div class="card-body">
                    <!-- Search Form -->
                    <form method="GET" action="{{ route('admin.penduduk.index') }}" class="mb-4">
                        <div class="row">
                            <div class="col-md-4">
                                <input type="text" name="search" class="form-control" placeholder="Pencarian" value="{{ request('search') }}">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-soft-primary">Cari</button>
                            </div>
                        </div>
                    </form>
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>NIK</th>
                                    <th>Nama Lengkap</th>
                                    <th>Jenis Kelamin</th>
                                    <th>Alamat</th>
                                    <th>Tanggal Lahir</th>
                                    <th>Agama</th>
                                    <th>Nomor KK</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($residents as $key => $penduduk)
                                <tr>
                                    <td>{{ $key + 1 }}</td>
                                    <td>{{ $penduduk->nik }}</td>
                                    <td>{{ $penduduk->name }}</td>
                                    <td>{{ $penduduk->gender_label }}</td>
                                    <td>{{ $penduduk->address }}</td>
                                    <td>{{ \Carbon\Carbon::parse($penduduk->birth_date)->format('d-m-Y') }}</td>
                                    <td>{{ $penduduk->religion }}</td>
                                    <td>{{ $penduduk->family_card_number }}</td>
                                    <td>
                                        <a href="{{ route('admin.penduduk.edit', $penduduk->id) }}" class="btn btn-sm btn-soft-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('admin.penduduk.destroy', $penduduk->id) }}" method="POST" style="display:inline;">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-soft-danger" onclick="return confirm('Yakin ingin menghapus?')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                @endforeach
                                @if ($residents->isEmpty())
                                <div class="col-12">
                            <p class="text-muted text-center">Belum ada Data Penduduk. Silahkan tambah Data Penduduk.</p>
                        </div>
                                @endif
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        {{ $residents->links('pagination::bootstrap-4') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
