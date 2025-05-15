<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Storage;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::paginate(5);
        return view('admin.layanan.index', ['products' => $products]);
    }

    public function create()
    {
        return view('admin.layanan.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'product_name' => 'required|string|max:255',
            'description' => 'required|string',
            'photo' => 'required|image|mimes:jpeg,png,jpg|max:5000',
            'location' => 'required|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'phone' => 'required|numeric',
        ]);

        $products = new Product([
            'product_name' => $request->get('product_name'),
            'description' => $request->get('description'),
            'location' => $request->get('location'),
            'price' => $request->get('price'),
            'stock' => $request->get('stock'),
            'phone' => $request->get('phone'),
        ]);

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $destinationPath = storage_path('app/public/photos');
            $file->move($destinationPath, $filename);
            $products->photo = 'photos/' . $filename;
        }

        $products->save();

        return redirect()->route('admin.layanan.index')->with('success', 'Produk berhasil ditambahkan');
    }

    public function edit(Product $products)
    {
        return view('admin.layanan.edit', compact('products'));
    }

    public function update(Request $request, Product $products)
    {
        $request->validate([
            'product_name' => 'required|string|max:255',
            'description' => 'required|string',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg|max:5000',
            'location' => 'required|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'phone' => 'required|numeric',
        ]);

        $data = [
            'product_name' => $request->product_name,
            'description' => $request->description,
            'location' => $request->location,
            'price' => $request->price,
            'stock' => $request->stock,
            'phone' => $request->phone,
        ];

        if ($request->hasFile('photo')) {
            // Hapus foto lama jika ada
            if ($products->photo && Storage::disk('public')->exists($products->photo)) {
                Storage::disk('public')->delete($products->photo);
            }

            // Simpan foto baru
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->storeAs('photos', $filename, 'public');
            $products->photo = 'photos/' . $filename;
        }

        $products->update($data);

        return redirect()->route('admin.layanan.index')->with('success', 'Produk berhasil diperbarui');
    }

    public function destroy($id)
    {
        $products = Product::findOrFail($id);

        if (Storage::disk('public')->exists('photos/' . $products->photo)) {
            Storage::disk('public')->delete('photos/' . $products->photo);
        }

        $products->delete();

        return redirect()->route('admin.layanan.index')->with('success', 'Produk berhasil dihapus');
    }
}
