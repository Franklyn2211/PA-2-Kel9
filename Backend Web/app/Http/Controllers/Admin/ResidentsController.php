<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Residents;
use Illuminate\Http\Request;

class ResidentsController extends Controller
{
    public function index()
    {
        $residents = Residents::all();
        return view('admin.penduduk.index', ['residents' => $residents]);
    }

    public function create()
    {
        return view('admin.penduduk.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'nik' => 'required|string|max:16|unique:residents,nik',
            'name' => 'required|string',
            'gender' => 'required|in:Male,Female',
            'address' => 'required|string',
            'birth_date' => 'required|date',
            'religion' => 'required|string|max:50',
            'family_card_number' => 'required|string|max:16',
        ]);

        $residents = new Residents([
            'nik' => $request->get('nik'),
            'name' => $request->get('name'),
            'gender' => $request->get('gender'),
            'address' => $request->get('address'),
            'birth_date' => $request->get('birth_date'),
            'religion' => $request->get('religion'),
            'family_card_number' => $request->get('family_card_number'),
        ]);

        $residents->save();

        return redirect()->route('admin.penduduk.index')->with('success', 'Data penduduk berhasil ditambahkan');
    }

    public function edit(Residents $residents)
    {
        return view('admin.penduduk.edit', compact('residents'));
    }

    public function update(Request $request, Residents $residents)
    {
        $request->validate([
            'nik' => 'required|string|max:16|unique:residents,nik,' . $residents->id,
            'name' => 'required|string|max:255',
            'gender' => 'required|in:Male,Female',
            'address' => 'required|string',
            'birth_date' => 'required|date',
            'religion' => 'required|string|max:50',
            'family_card_number' => 'required|string|max:16',
        ]);

        $data = [
            'nik' => $request->nik,
            'name' => $request->name,
            'gender' => $request->gender,
            'address' => $request->address,
            'birth_date' => $request->birth_date,
            'religion' => $request->religion,
            'family_card_number' => $request->family_card_number,
        ];

        $residents->update($data);

        return redirect()->route('admin.penduduk.index')->with('success', 'Data penduduk berhasil diperbarui');
    }

    public function destroy($id)
    {
        $residents = Residents::findOrFail($id);
        $residents->delete();

        return redirect()->route('admin.penduduk.index')->with('success', 'Data penduduk berhasil dihapus');
    }
    public function CheckNik(Request $request)
    {
        // Validasi parameter nik
        $request->validate([
            'nik' => 'nullable|digits:16'
        ]);

        $query = Residents::query();
        
        // Filter berdasarkan NIK jika parameter ada
        if ($request->has('nik')) {
            $query->where('nik', $request->nik);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Parameter NIK diperlukan',
                'data' => []
            ], 400);
        }

        $data = $query->get();

        return response()->json([
            'success' => true,
            'message' => $data->isEmpty() ? 'Data tidak ditemukan' : 'Data ditemukan',
            'data' => $data
        ]);
    }
}
