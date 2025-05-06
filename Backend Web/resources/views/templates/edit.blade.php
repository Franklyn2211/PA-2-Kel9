@extends('admin.layouts.app')

@section('content')
<div class="container">
    <h1>Edit Template Surat</h1>
    <form action="{{ route('templates.update', $template->id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')
        <div class="mb-3">
            <label for="nama_surat" class="form-label">Nama Surat</label>
            <input type="text" name="nama_surat" id="nama_surat" class="form-control" value="{{ $template->nama_surat }}" required>
        </div>
        <div class="mb-3">
            <label for="template" class="form-label">File Template (Opsional)</label>
            <input type="file" name="template" id="template" class="form-control">
        </div>
        <button type="submit" class="btn btn-success">Update</button>
    </form>
</div>
@endsection
