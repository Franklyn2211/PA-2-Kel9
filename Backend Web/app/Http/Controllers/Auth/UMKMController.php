<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\UMKM;
use Auth;
use Hash;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class UMKMController extends Controller
{
    public function showRegisterForm()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $request->validate([
            'nama_umkm' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:umkm',
            'phone' => 'required|regex:/^[0-9]{9,13}$/|unique:umkm', // Adjusted validation rule
            'password' => 'required|string|min:8|confirmed',
        ]);

        $phone = '+62' . $request->get('phone'); // Prepend +62 to the phone number

        $umkm = new UMKM([
            'nama_umkm' => $request->get('nama_umkm'),
            'email' => $request->get('email'),
            'phone' => $phone, // Save phone with +62 prefix
            'password' => Hash::make($request->password),
            'status' => false,
        ]);

        $umkm->save();
        return redirect()->route('login.umkm')->with('success', 'Pendaftaran berhasil! Tunggu persetujuan dari admin');
    }

    public function showLoginForm()
    {
        return view('auth.loginUMKM');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $credentials = $request->only('email', 'password');

        if (Auth::guard('umkm')->attempt($credentials)) {
            $request->session()->put('just_logged_in', true); // Set session flag
            $request->session()->put('session_key', 'umkm_session'); // Set UMKM session key
            $request->session()->regenerate();

            if (!Auth::guard('umkm')->user()->status) {
                Auth::guard('umkm')->logout();
                return back()->withErrors(['email' => 'Akun Anda belum disetujui oleh admin.']);
            }

            return redirect()->route('umkm.dashboard');
        }

        return back()->withErrors([
            'email' => 'Email atau password salah.',
        ])->withInput();
    }

    public function logout(Request $request)
    {
        Auth::guard('umkm')->logout();
        $request->session()->forget('session_key'); // Clear UMKM session key
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('login.umkm');
    }

    public function updateQRIS(Request $request)
    {
        $request->validate([
            'qris_image' => 'required|image|mimes:jpg,png,jpeg|max:2048',
        ]);

        $umkm = auth()->user(); // Get the authenticated UMKM user

        // Delete the old QRIS image if it exists
        if ($umkm->qris_image && Storage::disk('public')->exists($umkm->qris_image)) {
            Storage::disk('public')->delete($umkm->qris_image);
        }

        // Save the new QRIS image
        if ($request->hasFile('qris_image')) {
            $file = $request->file('qris_image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->storeAs('photos/qris', $filename, 'public');
            $umkm->qris_image = 'photos/qris/' . $filename;
        }

        $umkm->save();

        return back()->with('success', 'QRIS berhasil diupload.');
    }

    public function edit()
    {
        $umkm = auth()->user(); // Get the authenticated UMKM user
        return view('umkm.edit', compact('umkm')); // Return the edit view with UMKM data
    }

    public function update(Request $request)
    {
        $request->validate([
            'nama_umkm' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:umkm,email,' . auth()->id(),
            'phone' => 'required|regex:/^[0-9]{9,13}$/|unique:umkm,phone,' . auth()->id(),
        ]);

        $umkm = auth()->user(); // Get the authenticated UMKM user

        $umkm->update([
            'nama_umkm' => $request->get('nama_umkm'),
            'email' => $request->get('email'),
            'phone' => '+62' . ltrim($request->get('phone'), '0'), // Ensure phone starts with +62
        ]);

        return redirect()->route('umkm.profil')->with('success', 'Profil berhasil diperbarui.');
    }
}
