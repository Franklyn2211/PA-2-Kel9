<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'penduduk_id' => 'required|exists:resident,id',
            'product_id' => 'required|exists:products,id',
            'amount' => 'required|numeric',
            'note' => 'nullable|string',
            'bukti_transfer' => 'required|image|mimes:jpeg,png,jpg|max:5000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Upload bukti transfer
            $imagePath = $request->file('bukti_transfer')->store('payment_proofs', 'public');

            $order = Order::create([
                'penduduk_id' => $request->penduduk_id,
                'product_id' => $request->product_id,
                'amount' => $request->amount,
                'note' => $request->note,
                'bukti_transfer' => $imagePath,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Order created successfully',
                'data' => $order
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create order',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function getUserOrders(Request $request)
    {
        $userId = $request->input('user_id'); // Ambil user_id dari request body

        if (!$userId) {
            return response()->json(['error' => 'User ID is required'], 400);
        }

        $orders = Order::with(['product.umkm'])
            ->where('penduduk_id', $userId) 
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {

                $order->status = $order->status; // Tidak ada manipulasi
                return $order;
            });

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }
}
