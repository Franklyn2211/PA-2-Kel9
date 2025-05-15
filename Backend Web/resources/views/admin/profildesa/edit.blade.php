@extends('admin.layouts.app')

@section('title', 'Edit Profil Desa - Admin Desa Digital')

@section('page-title', 'Edit Profil Desa')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.profildesa.update', $profilDesa->id)}}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                        <!-- Sejarah -->
                        <div class="mb-3">
                            <label for="history" class="form-label">Sejarah</label>
                            <textarea name="history" id="summernote">{{ old('history', $profilDesa->history)}}</textarea>
                        </div>
                        <!-- Visi -->
                        <div class="mb-3">
                            <label for="visi" class="form-label">Visi</label>
                            <textarea name="visi" id="visi">{{old('visi', $profilDesa->visi)}}</textarea>
                        </div>
                        <!-- Misi -->
                        <div class="mb-3">
                            <label for="misi" class="form-label">Misi</label>
                            <textarea name="misi" id="misi">{{old('misi', $profilDesa->misi)}}</textarea>
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
