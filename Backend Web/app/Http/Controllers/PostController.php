<?php

namespace App\Http\Controllers;

use App\Http\Resources\Postresource;
use App\Models\Announcements;
use App\Models\News;
use App\Models\Product;
use App\Models\ProfilDesa;
use App\Models\Residents;
use App\Models\Umkm;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function getProduct()
    {
        $products = Product::with('umkm:id,nama_umkm,qris_image')->get();
        return PostResource::collection($products);
    }

    public function getNews()
    {
        $news = News::all();
        return Postresource::collection($news);
    }

    public function getResidents()
    {
        $residents = Residents::all();
        return Postresource::collection($residents);
    }

    public function getAnnouncements()
    {
        $announcements = Announcements::all();
        return Postresource::collection($announcements);
    }
    public function getUmkm()
    {
        $umkms = Umkm::all();
        return response()->json($umkms);
    }

    public function getProfilDesa()
    {
        $profilDesa = ProfilDesa::first();
        return new Postresource($profilDesa);
    }
}
