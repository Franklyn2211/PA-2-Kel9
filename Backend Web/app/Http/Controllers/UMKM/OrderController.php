<?php

namespace App\Http\Controllers\UMKM;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::paginate(5);
        return view('umkm.order.index', compact('orders'));
    }

    public function updateStatus($id)
    {
        $order = Order::findOrFail($id);
        $order->status = $order->status == true ? false : true;
        $order->save();
        return back()->with('success', 'Status order berhasil diperbarui.');
    }
}
