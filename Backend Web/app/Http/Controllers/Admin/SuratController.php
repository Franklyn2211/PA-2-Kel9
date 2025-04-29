<?php

namespace App\Http\Controllers;

use App\Models\PengajuanSurat;
use App\Models\Residents;
use Illuminate\Http\Request;

class SuratController extends Controller
{
    // Dashboard admin
    public function index()
    {
        // Ambil data resident dengan ID 3
        $resident = Residents::with('umkm')->findOrFail(3);

        // Jika ingin mengambil semua UMKM dari resident tertentu:
        // $umkm = Umkm::where('resident_id', 3)->get();

        return view('admin.surat.index', compact('resident'));
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