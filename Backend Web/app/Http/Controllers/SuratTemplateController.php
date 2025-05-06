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
        return view('templates.index', compact('templates'));
    }

    // Menampilkan form tambah template
    public function create()
    {
        return view('templates.create');
    }

    // Menyimpan template baru
    public function store(Request $request)
    {
        $request->validate([
            'jenis_surat' => 'required|unique:surat_templates',
            'nama_surat' => 'required',
            'template' => 'required|file|mimes:docx'
        ]);

        // Upload file template
        $path = $request->file('template')->store('templates');

        surat_templates::create([
            'jenis_surat' => $request->jenis_surat,
            'nama_surat' => $request->nama_surat,
            'template_path' => $path,
        ]);

        return redirect()->route('templates.index')
            ->with('success', 'Template berhasil ditambahkan');
    }

    // Menampilkan form edit template
    public function edit($id)
    {
        $template = surat_templates::findOrFail($id);
        return view('templates.edit', compact('template'));
    }

    // Update template
    public function update(Request $request, $id)
    {
        $template = surat_templates::findOrFail($id);
        
        $data = [
            'nama_surat' => $request->nama_surat,
        ];

        if ($request->hasFile('template')) {
            // Hapus file lama
            Storage::delete($template->template_path);
            
            // Upload file baru
            $data['template_path'] = $request->file('template')->store('templates');
        }

        $template->update($data);

        return redirect()->route('templates.index')
            ->with('success', 'Template berhasil diperbarui');
    }
    
    // Delete template
    public function destroy($id)
    {
        $template = surat_templates::findOrFail($id);

        // Hapus file template
        Storage::delete($template->template_path);

        // Hapus data dari database
        $template->delete();

        return redirect()->route('templates.index')
            ->with('success', 'Template berhasil dihapus');
    }
}