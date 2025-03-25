<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Announcements;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function index()
    {
        $announcements = Announcements::paginate(3);
        return view('admin.pengumuman.index', ['announcements' => $announcements]);
    }

    public function create()
    {
        return view('admin.pengumuman.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' =>'required|string|max:255',
            'description' =>'required',
        ]);

        $announcements = new Announcements([
            'title' => $request->get('title'),
            'description' => $request->get('description'),
        ]);

        $announcements->save();
        return redirect()->route('admin.pengumuman.index')->with('success', 'Pengumuman berhasil ditambahkan');
    }

    public function edit(Announcements $announcements)
    {
        return view('admin.pengumuman.edit', compact('announcements'));
    }

    public function update(Request $request, Announcements $announcements)
    {
        $request->validate([
            'title' =>'required|string|max:255',
            'description' =>'required',
        ]);

        $data = [
            'title' => $request->title,
            'description' => $request->description,
        ];

        $announcements->update($data);
        return redirect()->route('admin.pengumuman.index')->with('success', 'Pengumuman berhasil diubah');
    }

    public function destroy($id)
    {
        $announcements = Announcements::findOrFail($id);

        $announcements->delete();
        return redirect()->route('admin.pengumuman.index')->with('success', 'Pengumuman berhasil dihapus');
    }
}
