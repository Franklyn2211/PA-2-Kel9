<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProfilDesa;
use Illuminate\Http\Request;

class ProfilDesaController extends Controller
{
    public function index()
    {
        $profilDesa = ProfilDesa::first();
        $profilDesaExists = $profilDesa !== null;
        return view('admin.profildesa.index', compact('profilDesa', 'profilDesaExists'));
    }

    public function create()
    {
        return view('admin.profildesa.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'history' => 'required|string',
            'visi' => 'required|string',
            'misi' => 'required|string',
        ]);

        ProfilDesa::create($request->all());

        return redirect()->route('admin.profildesa.index')->with('success', 'Profil Desa berhasil ditambahkan');
   }

    public function edit(ProfilDesa $profilDesa)
    {
        return view('admin.profildesa.edit', compact('profilDesa'));
    }

    public function update(Request $request, ProfilDesa $profilDesa)
    {
        $request->validate([
            'history' => 'required|string',
            'visi' => 'required|string',
            'misi' => 'required|string',
        ]);

        $data = [
            'history' => $request->history,
            'visi' => $request->visi,
            'misi' => $request->misi,
        ];
        $profilDesa->update($data);

        return redirect()->route('admin.profildesa.index')->with('success', 'Profil Desa berhasil diperbarui');
    }

    public function destroy($id)
    {
        $profilDesa = ProfilDesa::findOrFail($id);
        $profilDesa->delete();
        return redirect()->route('admin.profildesa.index')->with('success', 'Profil Desa berhasil di hapus');
    }
}
