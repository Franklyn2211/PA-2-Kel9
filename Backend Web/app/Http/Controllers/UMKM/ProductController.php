<?php

namespace App\Http\Controllers\UMKM;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Storage;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::where('umkm_id', auth()->id())->paginate(5); // Filter by UMKM
        return view('umkm.layanan.index', ['products' => $products]);
    }

    public function create()
    {
        return view('umkm.layanan.create');
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
        ]);

        $data = [
            'product_name' => $request->get('product_name'),
            'description' => $request->get('description'),
            'location' => $request->get('location'),
            'price' => $request->get('price'),
            'stock' => $request->get('stock'),
            'phone' => auth()->user()->phone, // Use authenticated UMKM's phone
            'umkm_id' => auth()->id(), // Associate product with UMKM
        ];

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');
            $filename = time() . '_' . $file->getClientOriginalName();
            $destinationPath = storage_path('app/public/photos');
            $file->move($destinationPath, $filename);
            $data['photo'] = 'photos/' . $filename;
        }

        Product::create($data);

        return redirect()->route('umkm.products.index')->with('success', 'Produk berhasil ditambahkan');
    }

    public function edit(Product $products)
    {
        return view('umkm.layanan.edit', compact('products'));
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
        ]);

        $data = [
            'product_name' => $request->product_name,
            'description' => $request->description,
            'location' => $request->location,
            'price' => $request->price,
            'stock' => $request->stock,
            'phone' => auth()->user()->phone, // Use authenticated UMKM's phone
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
            $data['photo'] = 'photos/' . $filename;
        }

        $products->update($data);

        return redirect()->route('umkm.products.index')->with('success', 'Produk berhasil diperbarui');
    }

    public function destroy($id)
    {
        $products = Product::findOrFail($id);

        if (Storage::disk('public')->exists('photos/' . $products->photo)) {
            Storage::disk('public')->delete('photos/' . $products->photo);
        }

        $products->delete();

        return redirect()->route('umkm.products.index')->with('success', 'Produk berhasil dihapus');
    }
}
