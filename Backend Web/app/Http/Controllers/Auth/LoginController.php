<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login'); // Pastikan Anda punya view di resources/views/auth/login.blade.php
    }

    /**
     * Proses login pengguna.
     */
    public function login(Request $request)
    {
        // Validasi input dari form
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        // Data kredensial untuk autentikasi
        $credentials = $request->only('email', 'password');

        // Coba autentikasi pengguna
        if (Auth::attempt($credentials, $request->filled('remember'))) {
            // Regenerasi session untuk keamanan
            $request->session()->regenerate();

            // Redirect ke halaman setelah login berhasil (misalnya dashboard)
            return redirect()->intended(route('admin.dashboard')); // Ganti 'dashboard' dengan route Anda
        }

        // Jika login gagal, kembali ke form dengan pesan error
        return back()->withErrors([
            'email' => 'Email atau kata sandi salah.',
        ])->withInput($request->except('password'));
    }

    /**
     * Logout pengguna.
     */
    public function logout(Request $request)
    {
        Auth::logout();

        // Invalidasi session dan regenerasi token
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        // Redirect ke halaman login atau home
        return redirect('/login');
    }
}
