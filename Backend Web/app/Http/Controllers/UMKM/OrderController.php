<?php

namespace App\Http\Controllers\UMKM;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function index()
    {
        $umkmId = auth()->user()->umkm->id; // Mendapatkan ID UMKM dari user yang sedang login
        $orders = Order::where('umkm_id', $umkmId)->paginate(5); // Filter order berdasarkan UMKM ID
    }

    public function updateStatus($id)
    {
        $order = Order::findOrFail($id);
        $order->status = $order->status == true ? false : true;
        $order->save();
        return back()->with('success', 'Status order berhasil diperbarui.');
    }
}
