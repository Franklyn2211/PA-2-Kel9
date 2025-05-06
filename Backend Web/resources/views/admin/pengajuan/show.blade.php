@extends('admin.layouts.app')

@section('title', 'Detail Surat - Admin Desa Digital')

@section('page-title', 'Detail Surat')

@section('content')
    <div class="container-fluid" style="padding-top: 80px;">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h6>Detail Surat</h6>
                    </div>
                    <div class="card-body">
                        <ul class="list-group">
                            <li class="list-group-item"><strong>Nomor Surat:</strong> {{ $surat->nomor_surat }}</li>
                            <li class="list-group-item"><strong>Nama Penduduk:</strong> {{ $surat->resident->name ?? '-' }}</li>
                            <li class="list-group-item"><strong>Jenis Surat:</strong> {{ $surat->template->nama ?? '-' }}</li>
                            <li class="list-group-item"><strong>Tanggal Pengajuan:</strong> {{ $surat->tanggal_pengajuan ? $surat->tanggal_pengajuan->format('d F Y H:i') : '-' }}</li>
                            <li class="list-group-item"><strong>Status:</strong> {{ ucfirst($surat->status) }}</li>
                            <li class="list-group-item"><strong>Catatan Admin:</strong> {{ $surat->catatan_admin ?? '-' }}</li>
                            <li class="list-group-item"><strong>Feedback:</strong> {{ $surat->feedback ?? '-' }}</li>
                            <li class="list-group-item"><strong>Tanggal Selesai:</strong> {{ $surat->tanggal_diselesaikan ? $surat->tanggal_diselesaikan->format('d F Y H:i') : '-' }}</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
