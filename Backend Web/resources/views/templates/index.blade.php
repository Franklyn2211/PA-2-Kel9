@extends('admin.layouts.app')

@section('content')
    <div class="container">
        <h1>Daftar Template Surat</h1>
        <a href="{{ route('templates.create') }}" class="btn btn-primary">Tambah Template</a>
        <table class="table mt-3">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Jenis Surat</th>
                    <th>Nama Surat</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                @foreach($templates as $template)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $template->jenis_surat }}</td>
                        <td>{{ $template->nama_surat }}</td>
                        <td>
                            <a href="{{ route('templates.edit', $template->id) }}" class="btn btn-warning">Edit</a>
                            <form action="{{ route('admin.templates.destroy', $template->id) }}" method="POST"
                                style="display:inline;">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-soft-danger"
                                    onclick="return confirm('Yakin ingin menghapus?')">
                                    <i class="fas fa-trash me-1"></i> Hapus
                            </form>
                            </button>
                            </form>
                        </td>
                    </tr>

                @endforeach
            </tbody>
        </table>
    </div>
@endsection