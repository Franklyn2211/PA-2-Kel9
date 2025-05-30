@extends('admin.layouts.app')

@section('title', 'Daftar Template Surat')

@section('page-title', 'Template Surat')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Daftar Template Surat</h6>
                    <a href="{{ route('admin.templates.create') }}">
                        <button class="btn btn-sm btn-soft-primary">
                            <i class="fas fa-plus me-1"></i> Tambah Template
                        </button>
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive mt-2">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Jenis Surat</th>
                                    <th>Nama Surat</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @if ($templates->isEmpty())
                                <tr>
                                    <td colspan="4" class="text-center">Tidak ada template surat</td>
                                </tr>
                                @else
                                    @foreach ($templates as $key => $template)
                                    <tr>
                                        <td>{{ $key + 1 }}</td>
                                        <td>{{ $template->jenis_surat }}</td>
                                        <td>{{ $template->nama_surat }}</td>
                                        <td>
                                            <a href="{{ route('admin.templates.edit', $template->id) }}" class="btn btn-soft-primary btn-sm"><i class="fas fa-edit"></i></a>
                                            <form action="{{ route('admin.templates.destroy', $template->id) }}" method="POST" style="display:inline;">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-soft-danger btn-sm" onclick="return confirm('Yakin ingin menghapus?')">
                                                    <i class="fas fa-trash"></i>
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
                        {{ $templates->links('pagination::bootstrap-4') }}
                    </div> --}}
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
