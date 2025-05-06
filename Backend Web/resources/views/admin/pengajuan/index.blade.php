@extends('admin.layouts.app')

@section('title', 'Pengajuan Surat - Admin Desa Digital')

@section('page-title', 'Pengajuan Surat')

@section('content')
    <div class="container-fluid" style="padding-top: 80px;">
        <div class="row">
            <div class="col-12 mb-4">
                <div class="card animate-on-scroll fadeIn">
                    <div class="card-header">
                        <h6 class="mb-0">@yield('page-title')</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nama Penduduk</th>
                                        <th>Jenis Surat</th>
                                        <th>Tanggal Pengajuan</th>
                                        <th>Status</th>
                                        <th>Tanggal Selesai</th>
                                        <th>Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @if(isset($pengajuan) && $pengajuan->count() > 0)
                                        @foreach ($pengajuan as $key => $item)
                                            <tr>
                                                <td>{{ $key + 1 }}</td>
                                                <td>{{ $item->resident->name ?? '-' }}</td>
                                                <td>{{ $item->template->jenis_surat ?? '-' }}</td>
                                                <td>{{ $item->tanggal_pengajuan ? $item->tanggal_pengajuan->format('d F Y H:i') : '-' }}</td>
                                                <td>
                                                    @php
                                                        $badgeClass = [
                                                            'draft' => 'bg-secondary',
                                                            'diajukan' => 'bg-info',
                                                            'diproses' => 'bg-warning',
                                                            'disetujui' => 'bg-success',
                                                            'ditolak' => 'bg-danger'
                                                        ][$item->status] ?? 'bg-secondary';
                                                    @endphp
                                                    <span class="badge {{ $badgeClass }}">
                                                        {{ ucfirst($item->status) }}
                                                    </span>
                                                </td>
                                                <td>{{ $item->tanggal_diselesaikan ? $item->tanggal_diselesaikan->format('d F Y H:i') : '-' }}</td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        <a href="{{ route('admin.pengajuan.show', $item->id) }}" class="btn btn-sm btn-soft-primary">
                                                            <i class="fas fa-eye me-1"></i> Lihat
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        @endforeach
                                    @else
                                        <tr>
                                            <td colspan="10" class="text-center">Tidak ada data pengajuan surat.</td>
                                        </tr>
                                    @endif
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            @if(isset($detailPengajuan))
                <div class="col-12">
                    <div class="card mt-4">
                        <div class="card-header">
                            <h6>Detail Pengajuan</h6>
                        </div>
                        <div class="card-body">
                            <ul class="list-group">
                                @foreach ($detailPengajuan->toArray() as $key => $value)
                                    <li class="list-group-item">
                                        <strong>{{ ucfirst(str_replace('_', ' ', $key)) }}:</strong> {{ $value ?? '-' }}
                                    </li>
                                @endforeach
                            </ul>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
@endsection