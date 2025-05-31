@extends('admin.layouts.app')

@section('title', 'Edit Template Surat')
@section('page-title', 'Edit Template Surat')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.templates.update', $template->id) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')

                        <!-- Jenis Surat -->
                        <div class="mb-3">
                            <label for="jenis_surat" class="form-label">Jenis Surat</label>
                            <select id="jenis_surat" name="jenis_surat" class="form-select" required>
                                <option value="Surat Belum Menikah" {{ $template->jenis_surat == 'Surat Belum Menikah' ? 'selected' : '' }}>Surat Belum Menikah</option>
                                <option value="Surat Domisili" {{ $template->jenis_surat == 'Surat Domisili' ? 'selected' : '' }}>Surat Domisili</option>
                            </select>
                        </div>

                        <!-- Nama Surat -->
                        <div class="mb-3">
                            <label for="nama_surat" class="form-label">Nama Surat</label>
                            <input type="text" name="nama_surat" id="nama_surat" class="form-control" value="{{ $template->nama_surat }}" required>
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
