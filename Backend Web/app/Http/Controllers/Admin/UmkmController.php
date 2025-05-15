<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\UMKM;
use Illuminate\Http\Request;

class UmkmController extends Controller
{
    public function index()
    {
        $umkm = UMKM::all();
        return view('admin.umkm.index', compact('umkm'));
    }

    public function updateStatus($id)
    {
        $umkm = UMKM::findOrFail($id);
        $umkm->status = $umkm->status == true ? false : true;
        $umkm->save();
        return back()->with('success', 'Status UMKM berhasil diperbarui.');
    }
}
