<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Orders;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class OrdersController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'penduduk_id' => 'required|exists:penduduks,id',
            'product_id' => 'required|exists:products,id',
            'bukti_transfer' => 'required|image|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $buktiTransferPath = $request->file('bukti_transfer')->store('bukti_transfer', 'public');

        $order = Orders::create([
            'penduduk_id' => $request->penduduk_id,
            'product_id' => $request->product_id,
            'bukti_transfer' => $buktiTransferPath,
        ]);

        return response()->json(['message' => 'Order created successfully', 'order' => $order], 201);
    }
}
