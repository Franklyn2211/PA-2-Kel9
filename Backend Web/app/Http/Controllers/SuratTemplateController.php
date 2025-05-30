<?php

namespace App\Http\Controllers;

use App\Models\surat_templates;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class SuratTemplateController extends Controller
{
    // Menampilkan daftar template
    public function index()
    {
        $templates = surat_templates::all();
        return view('admin.templates.index', compact('templates'));
    }

    // Menampilkan form tambah template
    public function create()
    {
        return view('admin.templates.create');
    }

    // Menyimpan template baru
    public function store(Request $request)
    {
        // Validasi input
        $request->validate([
            'jenis_surat' => 'required|unique:surat_templates',
            'nama_surat' => 'required',
        ]);

        try {

            // Simpan data template ke database
            surat_templates::create([
                'jenis_surat' => $request->jenis_surat,
                'nama_surat' => $request->nama_surat,
            ]);

            // Redirect dengan pesan sukses
            return redirect()->route('admin.templates.index')
                ->with('success', 'Template berhasil ditambahkan');
        } catch (\Exception $e) {
            // Tangani error dan tampilkan pesan
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }

    // Menampilkan form edit template
    public function edit($id)
    {
        $template = surat_templates::findOrFail($id);
        return view('admin.templates.edit', compact('template'));
    }

    // Update template
    public function update(Request $request, $id)
    {
        $template = surat_templates::findOrFail($id);

        $data = [
            'nama_surat' => $request->nama_surat,
        ];

        $template->update($data);

        return redirect()->route('admin.templates.index')
            ->with('success', 'Template berhasil diperbarui');
    }

    // Delete template
    public function destroy($id)
    {
        $template = surat_templates::findOrFail($id);

        // Hapus data dari database
        $template->delete();

        return redirect()->route('admin.templates.index')
            ->with('success', 'Template berhasil dihapus');
    }
}
