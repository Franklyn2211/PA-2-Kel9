<?php

namespace App\Http\Controllers;

use App\Models\PengajuanSurat;
use Illuminate\Http\Request;

class SuratController extends Controller
{
    // Dashboard admin
    public function dashboard()
    {
        $pengajuanTerbaru = PengajuanSurat::with(['resident', 'template'])
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();
            
        $stats = [
            'total' => PengajuanSurat::count(),
            'diajukan' => PengajuanSurat::where('status', 'diajukan')->count(),
            'diproses' => PengajuanSurat::where('status', 'diproses')->count(),
            'disetujui' => PengajuanSurat::where('status', 'disetujui')->count(),
        ];

        return view('admin.dashboard', compact('pengajuanTerbaru', 'stats'));
    }

    // Daftar pengajuan
    public function pengajuan(Request $request)
    {
        $status = $request->get('status', 'diajukan');
        
        $pengajuan = PengajuanSurat::with(['resident', 'template'])
            ->where('status', $status)
            ->orderBy('created_at', 'desc')
            ->paginate(15);
            
        return view('admin.pengajuan', compact('pengajuan', 'status'));
    }

    // Detail pengajuan untuk admin
    public function detailPengajuan($id)
    {
        $pengajuan = PengajuanSurat::with(['resident', 'template'])->findOrFail($id);
        
        // Ambil data khusus berdasarkan jenis surat
        $detailPengajuan = null;
        switch ($pengajuan->template->jenis_surat) {
            case 'surat_tidak_mampu':
                $detailPengajuan = SuratTidakMampu::where('pengajuan_id', $id)->first();
                break;
            
            // Tambahkan case untuk jenis surat lainnya
        }

        return view('admin.detail_pengajuan', compact('pengajuan', 'detailPengajuan'));
    }
}