<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Staff;
use Illuminate\Http\Request;
use Storage;

class StaffController extends Controller
{
    public function index()
    {
        $staff = Staff::paginate(5);
        return view('admin.staff.index', compact('staff'));
    }
    public function create()
    {
        return view('admin.staff.create');
    }
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'position' => 'required|string|max:255',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5000',
            'email' => 'required|unique:staff|email|max:255',
            'phone' => 'required|numeric|regex:/^[0-9]{9,13}$/|unique:staff',
            'npsn_active' => 'required|date',
        ]);

        $phone = '+62' . $request->get('phone'); // Prepend +62 to the phone number

        $staff = new Staff([
            'name' => $request->get('name'),
            'position' => $request->get('position'),
            'email' => $request->get('email'),
            'phone' => $phone, // Menambahkan prefix 62
            'npsn_active' => $request->get('npsn_active'),
        ]);

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '.' . $file->getClientOriginalName();
            $destinationPath = storage_path('app/public/photos/staff');
            $file->move($destinationPath, $filename);
            $staff->photo = 'photos/staff/' . $filename;
        }

        $staff->save();

        return redirect()->route('admin.staff.index')->with('success', 'Data staff berhasil ditambahkan');
    }
    public function edit(Staff $staff)
    {
        return view('admin.staff.edit', compact('staff'));
    }
    public function update(Request $request, Staff $staff)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'position' => 'required|string|max:255',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5000',
            'npsn_active' => 'required|date',
            'email' => 'required|email|max:255|unique:staff,email,' . $staff->id,
            'phone' => 'required|numeric|regex:/^[0-9]{9,13}$/|unique:staff,phone,' . $staff->id,
        ]);

        $data = [
            'name' => $request->name,
            'position' => $request->position,
            'email' => $request->email,
            'npsn_active' => $request->npsn_active,
            'phone' => '+62' . $request->phone, // Menambahkan prefix 62
        ];

        if ($request->hasFile('photo')) {
            if ($staff->photo && Storage::disk('public')->exists($staff->photo)) {
                Storage::disk('public')->delete($staff->photo);
            }

            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->storeAs('photos/staff', $filename, 'public');
            $staff->photo = 'photos/staff/' . $filename;
        }

        $staff->update($data);

        return redirect()->route('admin.staff.index')->with('success', 'Data staff berhasil diperbarui');
    }
    public function destroy($id)
    {
        $staff = Staff::findOrFail($id);
        if (Storage::disk('public')->exists('photos/staff/' . $staff->photo)) {
            Storage::disk(name: 'public')->delete('photos/staff/' . $staff->photo);
        }
        $staff->delete();
        return redirect()->route('admin.staff.index')->with('success', 'Data staff berhasil dihapus');
    }
}
