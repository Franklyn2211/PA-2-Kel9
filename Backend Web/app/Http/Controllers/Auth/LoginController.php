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
            // Set Admin session key
            $request->session()->put('session_key', config('session.cookie'));
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

        // Clear Admin session key
        $request->session()->forget('session_key');
        // Invalidasi session dan regenerasi token
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        // Redirect ke halaman login atau home
        return redirect('/login');
    }

    /**
     * Show the edit profile form.
     */
    public function editProfile()
    {
        return view('admin.edit'); // Pastikan view ini sudah ada
    }

    /**
     * Update the admin profile.
     */
    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        // Validate input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'password' => 'nullable|string|min:8|confirmed',
        ]);

        // Update name and email
        $user->name = $request->input('name');
        $user->email = $request->input('email');

        // Update password if provided
        if ($request->filled('password')) {
            $user->password = bcrypt($request->input('password'));
        }

        // Save changes
        $user->save();

        // Redirect back with success message
        return redirect()->route('admin.profil')->with('success', 'Profile updated successfully.');
    }
}
