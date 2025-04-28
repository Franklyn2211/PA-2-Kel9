<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Gallery;
use Illuminate\Http\Request;
use Storage;

class GalleryController extends Controller
{
    public function index()
    {
        $galleries = Gallery::paginate(3);
        return view('admin.galeri.index', compact('galleries'));
    }

    public function create()
    {
        return view('admin.galeri.create');
    }
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'photo' => 'required|image|mimes:jpeg,png,jpg|max:5000',
            'date_taken' => 'date',
        ]);

        $galleries = new Gallery([
            'title' => $request->get('title'),
            'date_taken' => $request->get('date_taken'),
        ]);

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $destinationPath = storage_path('app/public/photos/galeri');
            $file->move($destinationPath, $filename);
            $galleries->photo = 'photos/galeri/' . $filename;
        }

        $galleries->save();

        return redirect()->route('admin.galeri.index')->with('success', 'Galeri berhasil ditambahkan');
    }
    public function edit(Gallery $galleries)
    {
        return view('admin.galeri.edit', compact('galleries'));
    }
    public function update(Request $request, Gallery $galleries)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:5000',
            'date_taken' => 'date',
        ]);

        $data = [
            'title' => $request->get('title'),
            'date_taken' => $request->get('date_taken'),
        ];
        if ($request->hasFile('photo')) {
            if ($galleries->photo && Storage::disk('public')->exists($galleries->photo)) {
                Storage::disk('public')->delete($galleries->photo);
            }

            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->storeAs('photos/galeri', $filename, 'public');
            $galleries->photo = 'photos/galeri/' . $filename;
        }
        $galleries->update($data);
        return redirect()->route('admin.galeri.index')->with('success', 'Galeri berhasil diperbarui');
    }
    public function destroy($id)
    {
        $galleries = Gallery::findOrFail($id);
        if (Storage::disk('public')->exists('photos/galeri/' . $galleries->photo)) {
            Storage::disk('public')->delete('photos/galeri/' . $galleries->photo);
        }
        $galleries->delete();
        return redirect()->route('admin.galeri.index')->with('success', 'Galeri berhasil dihapus');
    }
}
