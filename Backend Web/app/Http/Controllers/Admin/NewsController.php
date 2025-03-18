<?php

namespace App\Http\Controllers\Admin;

use App\Models\News;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Storage;


class NewsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $news = News::paginate(3);
        return view('admin.berita.index', ['news' => $news]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admin.berita.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' =>'required|string|max:255',
            'description' =>'required',
            'photo' =>'required|image|mimes:jpeg,png,jpg|max:5000',
        ]);

        $news = new News([
            'title' => $request->get('title'),
            'description' => $request->get('description'),
        ]);

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $destinationPath = storage_path('app/public/photos/berita');
            $file->move($destinationPath, $filename);
            $news->photo = 'photos/berita/' . $filename;
        }

        $news->save();
        return redirect()->route('admin.berita.index')->with('success', 'Berita berhasil ditambahkan');
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(News $news)
    {
        return view('admin.berita.edit', compact('news'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, News $news)
    {
        $request->validate([
            'title' =>'required|string|max:255',
            'description' =>'required',
            'photo' =>'nullable|image|mimes:jpeg,png,jpg|max:5000',
        ]);

        $data = [
            'title' => $request->title,
            'description' => $request->description,
        ];

        if ($request->hasFile('photo')) {
            // Hapus foto lama jika ada
            if ($news->photo && Storage::disk('public')->exists($news->photo)) {
                Storage::disk('public')->delete($news->photo);
            }

            // Simpan foto baru
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->storeAs('photos', $filename, 'public');
            $news->photo = 'photos/berita/' . $filename;
        }

        $news->update($data);

        return redirect()->route('admin.berita.index')->with('success', 'Berita berhasil diubah');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $news = News::findOrFail($id);

        if (Storage::disk('public')->exists('photos/berita/' . $news->photo)) {
            Storage::disk('public')->delete('photos/berita/' . $news->photo);
        }

        $news->delete();

        return redirect()->route('admin.berita.index')->with('success', 'Berita berhasil dihapus');
    }
}
