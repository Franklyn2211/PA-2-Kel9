@extends('admin.layouts.app')

@section('title', 'Edit Staff - Admin Desa Ambarita')

@section('page-title', 'Edit Staff')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">@yield('page-title')</h6>
                </div>
                <div class="card-body">
                    <form action="{{ route('admin.staff.update', $staff->id) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')
                        <!-- Nama Lengkap -->
                        <div class="mb-3">
                            <label for="name" class="form-label">Nama Lengkap</label>
                            <input type="text" name="name" id="name" class="form-control" value="{{old('name', $staff->name)}}" required>
                        </div>

                        <!-- Jabatan -->
                        <div class="mb-3">
                            <label for="position" class="form-label">Jabatan</label>
                            <input type="text" name="position" id="position" class="form-control" value="{{old('position', $staff->position)}}" required>
                        </div>

                        <!-- Nomor HP -->
                        <div class="input-group mb-3">
                            <span class="input-group-text">+62</span>
                            <input type="text" name="phone" class="form-control" placeholder="859..." required maxlength="11" value="{{old('phone', substr($staff->phone, 3))}}"
                                oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                pattern="[0-9]{9,13}">
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="text" name="email" id="email" class="form-control" value="{{old('email', $staff->email)}}" required>
                        </div>

                        <!-- NPSN -->
                        <div class="mb-3">
                            <label for="npsn_active" class="form-label">NPSN</label>
                            <input type="date" name="npsn_active" id="npsn_active" class="form-control" value="{{old('npsn_active', $staff->npsn_active)}}" required>
                        </div>

                        <!-- Foto -->
                        <div class="mb-3">
                            <label for="photo" class="form-label">Foto</label>
                            @if ($staff->photo)
                                <div class="mb-2">
                                    <img src="{{ asset('storage/' . $staff->photo) }}" alt="Foto" width="150">
                                </div>
                            @endif
                            <input type="file" name="photo" id="photo" class="form-control" accept="image/*">
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
