<?php

namespace App\Http\Controllers;

use App\Http\Resources\Postresource;
use App\Models\Announcements;
use App\Models\News;
use App\Models\Product;
use App\Models\Residents;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function getProduct(){
        $products = Product::all();
        return Postresource::collection($products);
    }

    public function getNews(){
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
}
