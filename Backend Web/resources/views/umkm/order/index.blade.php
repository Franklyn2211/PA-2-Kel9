@extends('umkm.layouts.app')

@section('title', 'Daftar Pesanan - UMKM Desa Ambarita')

@section('page-title', 'Daftar Pesanan')

@section('content')
<div class="container-fluid" style="padding-top: 80px;">
    <div class="row">
        <div class="col-12">
            <div class="card animate-on-scroll fadeIn">
                <div class="card-header">
                    <h6 class="mb-0">Daftar Pesanan</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th>Nama Pemesan</th>
                                    <th>Nama Produk</th>
                                    <th>Total Harga</th>
                                    <th>Bukti Transfer</th>
                                    <th>Pesan</th>
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($orders as $key => $order)
                                <tr>
                                    <td>{{ $key + 1 }}</td>
                                    <td>{{ $order->penduduk->name }}</td>
                                    <td>{{ $order->product->product_name }}</td>
                                    <td>Rp {{ number_format($order->amount, 0, ',', '.') }}</td>
                                    <td>
                                        @if($order->bukti_transfer)
                                            <a href="{{ asset('storage/'.$order->bukti_transfer) }}" target="_blank">
                                                Lihat Bukti
                                            </a>
                                        @else
                                            Belum ada bukti
                                        @endif
                                    </td>
                                    <td>{{ $order->note ?? '-' }}</td>
                                    <td>
                                        <span class="badge bg-{{ $order->status ? 'success' : 'warning' }}">
                                            {{ $order->status ? 'Diterima' : 'Pending' }}
                                        </span>
                                    </td>
                                    <td>
                                        @if(!$order->status)
                                            <form action="{{ route('umkm.order.status', $order->id) }}" method="POST" class="d-inline">
                                                @csrf
                                                @method('PATCH')
                                                <button type="submit" class="btn btn-sm btn-success">
                                                    Terima
                                                </button>
                                            </form>
                                        @endif
                                    </td>
                                </tr>
                                @endforeach
                                @if ($orders->isEmpty())
                                <tr>
                                    <td colspan="8" class="text-center">Tidak ada pesanan</td>
                                </tr>
                                @endif
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        {{ $orders->links('pagination::bootstrap-4') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
