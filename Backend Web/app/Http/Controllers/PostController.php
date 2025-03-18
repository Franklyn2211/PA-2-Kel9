<?php

namespace App\Http\Controllers;

use App\Http\Resources\Postresource;
use App\Models\Product;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function getProduct(){
        $products = Product::all();

        return Postresource::collection($products);
    }
}
