<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Penduduk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class PendudukController extends Controller
{    
    // Register
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nik' => 'required|string|size:16|unique:penduduk',
            'password' => 'required|string|min:6',
            'name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }
        
        $penduduk = Penduduk::create([
            'nik' => $request->nik,
            'name' => $request->name,
            'password' => Hash::make($request->password),
        ]);
        
        $token = $penduduk->createToken('auth_token')->plainTextToken;
        
        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil',
            'data' => [
                'user' => $penduduk,
                'access_token' => $token,
                'token_type' => 'Bearer'
            ]
        ], 201);
    }
}