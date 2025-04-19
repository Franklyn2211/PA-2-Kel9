@extends('admin.layouts.app')

@section('title', 'Data Staff - Admin Desa Digital')

@section('page-title', 'Data Staff')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Data Staff</h6>
                    <a href="{{ route('admin.staff.create') }}">
                        <button class="btn btn-sm btn-soft-primary">
                            <i class="fas fa-plus me-1"></i> Tambah Staff
                        </button>
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Foto</th>
                                    <th>Nama Lengkap</th>
                                    <th>Jabatan</th>
                                    <th>Nomor HP</th>
                                    <th>Email</th>
                                    <th>NPSN</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($staff as $key => $staffs)
                                <tr>
                                    <td>{{ $key + 1 }}</td>
                                    <td>
                                        @if ($staffs->photo)
                                            <img src="{{ asset('storage/' . $staffs->photo) }}" alt="Foto Staff" class="img-fluid" style="width: 50px; height: 50px; object-fit: cover;">
                                        @else
                                            <img src="{{ asset('images/default.png') }}" alt="Foto Staff" class="img-fluid" style="width: 50px; height: 50px; object-fit: cover;">
                                        @endif
                                    </td>
                                    <td>{{ $staffs->name }}</td>
                                    <td>{{ $staffs->position }}</td>
                                    <td>{{ $staffs->phone }}</td>
                                    <td>{{ $staffs->email }}</td>
                                    <td>{{ $staffs->npsn_active }}</td>
                                    <td>
                                        <a href="{{ route('admin.staff.edit', $staffs->id) }}" class="btn btn-sm btn-soft-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('admin.staff.destroy', $staffs->id) }}" method="POST" style="display:inline;">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-soft-danger" onclick="return confirm('Yakin ingin menghapus?')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                @endforeach
                                @if ($staff->isEmpty())
                                <tr>
                                    <td colspan="9" class="text-center">Data Staff Kosong</td>
                                </tr>
                                @endif
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        {{ $staff->links('pagination::bootstrap-4') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
