<?php

namespace App\Http\Controllers;

use App\Models\Penduduk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'nik' => 'required|digits:16',
            'password' => 'required|min:6'
        ]);

        $penduduk = Penduduk::where('nik', $request->nik)->first();

        if (!$penduduk || !Hash::check($request->password, $penduduk->password)) {
            return response()->json([
                'success' => false,
                'message' => 'NIK atau password salah'
            ], 401);
        }

        $token = $penduduk->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'access_token' => $token,
            'token_type' => 'Bearer',
            'data' => $penduduk
        ]);
    }
}