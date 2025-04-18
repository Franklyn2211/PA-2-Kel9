@extends('admin.layouts.app')

@section('title', 'Tambah Profil Desa - Admin Desa Digital')

@section('page-title', 'Tambah Profil Desa')

@section('content')

<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.profildesa.store')}}" method="POST" enctype="multipart/form-data">
                    @csrf
                        <!-- Sejarah -->
                        <div class="mb-3">
                            <label for="history" class="form-label">Sejarah</label>
                            <textarea name="history" id="summernote" required></textarea>
                        </div>
                        <!-- Visi -->
                        <div class="mb-3">
                            <label for="visi" class="form-label">Visi</label>
                            <textarea name="visi" id="visi" required></textarea>
                        </div>
                        <!-- Misi -->
                        <div class="mb-3">
                            <label for="misi" class="form-label">Misi</label>
                            <textarea name="misi" id="misi" required></textarea>
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Tambah Profil Desa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
