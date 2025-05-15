@extends('admin.layouts.app')

@section('title', 'UMKM - Admin Desa Ambarita')

@section('page-title', 'UMKM')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Daftar UMKM</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Nama UMKM</th>
                                    <th>Email</th>
                                    <th>Telepon</th>
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @if ($umkm->isEmpty())
                                <tr>
                                    <td colspan="6" class="text-center">Tidak ada data umkm</td>
                                </tr>
                                @else
                                    @foreach ($umkm as $key => $umkm)
                                    <tr>
                                        <td>{{ $key + 1 }}</td>
                                        <td>{{ $umkm->nama_umkm }}</td>
                                        <td>{{ $umkm->email }}</td>
                                        <td>{{ $umkm->phone }}</td>
                                        <td>
                                            @if ($umkm->status)
                                                <span class="text-success">Disetujui</span>
                                            @else
                                                <span class="text-danger">Belum disetujui</span>
                                            @endif
                                        </td>
                                        <td>
                                            <form action="{{ route('admin.umkm.updateStatus', $umkm->id) }}" method="post">
                                                @csrf
                                                @method('PATCH')
                                                <button type="submit" class="btn btn-sm {{ $umkm->status ? 'btn-danger' : 'btn-soft-primary' }}">
                                                    {{ $umkm->status ? 'Tolak' : 'Setujui' }}
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    @endforeach
                                @endif
                            </tbody>
                        </table>
                    </div>
                    {{-- <div class="d-flex justify-content-end mt-3">
                        {{ $umkm->links('pagination::bootstrap-4') }}
                    </div> --}}
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
