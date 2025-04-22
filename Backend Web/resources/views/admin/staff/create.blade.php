@extends('admin.layouts.app')

@section('title', 'Tambah Staff - Admin Desa Ambarita')

@section('page-title', 'Tambah Staff')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.staff.store') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <!-- Nama Lengkap -->
                        <div class="mb-3">
                            <label for="name" class="form-label">Nama Lengkap</label>
                            <input type="text" name="name" id="name" class="form-control" required>
                        </div>

                        <!-- Jabatan -->
                        <div class="mb-3">
                            <label for="position" class="form-label">Jabatan</label>
                            <input type="text" name="position" id="position" class="form-control" required>
                        </div>

                        <!-- Nomor HP -->
                        <div class="input-group mb-3">
                            <span class="input-group-text">+62</span>
                            <input type="text" name="phone" class="form-control" placeholder="859..." maxlength="11" required
                                oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                pattern="[0-9]{9,13}">
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="text" name="email" id="email" class="form-control" required>
                        </div>

                        <!-- NPSN -->
                        <div class="mb-3">
                            <label for="npsn_active" class="form-label">Masa Aktif NPSN</label>
                            <input type="date" name="npsn_active" id="npsn_active" class="form-control" required>
                        </div>

                        <!-- Foto -->
                        <div class="mb-3">
                            <label for="photo" class="form-label">Foto</label>
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*">
                        </div>

                        <!-- Tombol Submit -->
                        <button type="submit" class="btn btn-soft-primary">Tambah Staff</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
