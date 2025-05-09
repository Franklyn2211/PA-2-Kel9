<?php

namespace App\Http\Controllers\UMKM;

use App\Http\Controllers\Controller;
use App\Models\UMKM;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $umkmId = auth()->user()->id;

        // Ambil data pesanan per bulan
        $orders = DB::table('orders')
            ->join('products', 'orders.product_id', '=', 'products.id')
            ->where('products.umkm_id', $umkmId)
            ->selectRaw('MONTH(orders.created_at) as month, COUNT(*) as count')
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        // Format data untuk chart
        $months = collect(range(1, 12))->map(function ($month) {
            return Carbon::create()->month($month)->translatedFormat('F');
        })->toArray();

        $ordersPerMonth = array_fill(0, 12, 0);
        foreach ($orders as $order) {
            $ordersPerMonth[$order->month - 1] = $order->count;
        }

        return view('umkm.dashboard', [
            'pesananBelumDiterima' => DB::table('orders')
                ->join('products', 'orders.product_id', '=', 'products.id')
                ->where('products.umkm_id', $umkmId)
                ->where('orders.status', '0')
                ->count(),
            'pesananSudahDiterima' => DB::table('orders')
                ->join('products', 'orders.product_id', '=', 'products.id')
                ->where('products.umkm_id', $umkmId)
                ->where('orders.status', '1')
                ->count(),
            'months' => $months,
            'ordersPerMonth' => $ordersPerMonth,
        ]);
    }
}
