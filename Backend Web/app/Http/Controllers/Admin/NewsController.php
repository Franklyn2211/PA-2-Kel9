<?php

namespace App\Http\Controllers\Admin;

use App\Models\News;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;

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
            'title' => 'required|string|max:255',
            'description' => 'required',
            'photo' => 'required|image|mimes:jpeg,png,jpg|max:5000',
        ]);

        // Clean HTML tags from description
        $cleanDescription = strip_tags($request->description);

        $news = new News([
            'title' => $request->title,
            'description' => $cleanDescription, // Use cleaned description
        ]);

        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('photos/berita', 'public');
            $news->photo = $path;
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
            'title' => 'required|string|max:255',
            'description' => 'required',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:5000',
        ]);

        // Clean HTML tags from description
        $cleanDescription = strip_tags($request->description);

        $news->title = $request->title;
        $news->description = $cleanDescription; // Use cleaned description

        if ($request->hasFile('photo')) {
            // Delete old photo if exists
            if ($news->photo) {
                Storage::disk('public')->delete($news->photo);
            }

            $path = $request->file('photo')->store('photos/berita', 'public');
            $news->photo = $path;
        }

        $news->save();

        return redirect()->route('admin.berita.index')->with('success', 'Berita berhasil diubah');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $news = News::findOrFail($id);

        if ($news->photo) {
            Storage::disk('public')->delete($news->photo);
        }

        $news->delete();

        return redirect()->route('admin.berita.index')->with('success', 'Berita berhasil dihapus');
    }
}