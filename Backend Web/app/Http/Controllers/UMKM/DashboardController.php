<?php

namespace App\Http\Controllers\UMKM;

use App\Http\Controllers\Controller;
use App\Models\UMKM;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        return view('umkm.dashboard');
    }
}
