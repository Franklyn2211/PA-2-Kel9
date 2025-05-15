@extends('admin.layouts.app')

@section('title', 'Profil Admin')

@section('page-title', 'Profil Admin')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header text-center">
                    <h5 class="mb-0">Profil Admin</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <!-- Nama Admin -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nama Admin</label>
                            <p class="form-control-plaintext">{{ auth()->user()->name }}</p>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <p class="form-control-plaintext">{{ auth()->user()->email }}</p>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="text-center mt-4">
                                <a href="{{route('admin.profil.edit')}}" class="btn btn-soft-primary me-2">
                                    <i class="fas fa-edit"></i> Edit Profil
                                </a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
