<?php

namespace App\Http\Controllers;

use App\Models\pengajuan_surat;
use App\Models\Residents;
use Illuminate\Http\Request;

class SuratController extends Controller
{
    // Dashboard admin
    public function index()
    {
        $pengajuan = pengajuan_surat::with(['resident', 'template'])->orderBy('created_at', 'desc')->get();

        return view('admin.surat.index', compact('pengajuan'));
    }
    // Dashboard admin
    public function dashboard()
    {
        $totalPengajuan = pengajuan_surat::count();
        $totalResidents = Residents::count();
        $recentPengajuan = pengajuan_surat::with(['resident', 'template'])
            ->orderBy('created_at', 'desc')
            ->take(5)
            ->get();

        return view('admin.dashboard', compact('totalPengajuan', 'totalResidents', 'recentPengajuan'));
    }

    // Daftar pengajuan
    public function pengajuan(Request $request)
    {
        $status = $request->get('status', 'diajukan');

        $pengajuan = pengajuan_surat::with(['resident', 'template'])
            ->where('status', $status)
            ->orderBy('created_at', 'desc')
            ->paginate(15);

        return view('admin.pengajuan.index', compact('pengajuan', 'status'));
    }

    // Detail pengajuan untuk admin
    public function detailPengajuan($id)
    {
        $pengajuan = pengajuan_surat::with(['resident', 'template'])->findOrFail($id);

        // Ambil data khusus berdasarkan jenis surat
        $detailPengajuan = null;
        switch ($pengajuan->template->jenis_surat) {
            case 'surat_tidak_mampu':
                $detailPengajuan = SuratTidakMampu::where('pengajuan_id', $id)->first();
                break;

            // Tambahkan case untuk jenis surat lainnya
        }

        return view('admin.pengajuan.detail', compact('pengajuan', 'detailPengajuan'));
    }

    public function show($id)
    {
        $surat = Surat::findOrFail($id); // Replace 'Surat' with the actual model name if different
        return view('admin.surat.show', compact('surat'));
    }
}