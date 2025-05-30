<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\pengajuan_surat;
use App\Models\Residents;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $totalPengajuan = pengajuan_surat::count();
        $recentPengajuan = pengajuan_surat::with(['resident'])
            ->orderBy('created_at', 'desc')
            ->take(5)
            ->get();
        $totalPenduduk = Residents::count();
        $pendudukBaru = Residents::whereMonth('created_at', now()->month)->count();

        // Demografi Penduduk
        $lakiLaki = Residents::where('gender', 'Male')->count();
        $perempuan = Residents::where('gender', 'Female')->count();
        $totalDemografi = $lakiLaki + $perempuan;

        $demografi = [
            'lakiLaki' => $totalDemografi > 0 ? round(($lakiLaki / $totalDemografi) * 100, 2) : 0,
            'perempuan' => $totalDemografi > 0 ? round(($perempuan / $totalDemografi) * 100, 2) : 0,
        ];

        return view('admin.dashboard', compact(
            'totalPenduduk',
            'pendudukBaru',
            'demografi',
            'totalPengajuan',
            'recentPengajuan'
        ));
    }
}
