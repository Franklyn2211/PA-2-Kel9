<?php

namespace App\Http\Controllers;

use App\Http\Resources\GaleriResource;
use App\Http\Resources\PengumumanResource;
use App\Http\Resources\Postresource;
use App\Http\Resources\Pendudukresource;
use App\Http\Resources\Profilresource;
use App\Http\Resources\Staffresource;
use App\Models\Announcements;
use App\Models\Gallery;
use App\Models\News;
use App\Models\Product;
use App\Models\ProfilDesa;
use App\Models\Resident;
use App\Models\Residents;
use App\Models\Staff;
use App\Models\UMKM;
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
        return PendudukResource::collection($residents);
    }
    public function getPenduduk()
    {
        $penduduk = Resident::all();
        return Pendudukresource::collection($penduduk);
    }

    public function getAnnouncements()
    {
        $announcements = Announcements::all();
        return pengumumanResource::collection($announcements);
    }
    public function getUmkm()
    {
        $umkms = Umkm::all();
        return response()->json($umkms);
    }

    public function getProfilDesa()
    {
        $profilDesa = ProfilDesa::first();
        return new ProfilResource($profilDesa);
    }

    public function getStaff()
    {
        $staff = Staff::all();
        return StaffResource::collection($staff);
    }
    public function getGallery()
    {
        $galleries = Gallery::all();
        return GaleriResource::collection($galleries);
    }
}
