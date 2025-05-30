<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\pengajuan_surat;
use App\Models\Residents;
use App\Models\surat_belum_menikah;
use App\Models\surat_templates;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SuratBelumMenikahController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'resident_id' => 'required|exists:residents,id',
            'keperluan' => 'required',
            'nomor_telepon' => 'required'
        ]);

        DB::beginTransaction();

        try {
            // Cari template surat belum menikah
            $template = surat_templates::where('jenis_surat', 'surat belum menikah')->first();

            if (!$template) {
                throw new \Exception("Template surat belum menikah belum tersedia");
            }

            // Buat pengajuan umum
            $pengajuan = pengajuan_surat::create([
                'resident_id' => $request->resident_id,
                'jenis_surat' => $template->jenis_surat,
                'status' => 'diajukan'
            ]);

            // Buat data khusus surat belum menikah
            $suratBelumMenikah = surat_belum_menikah::create([
                'pengajuan_id' => $pengajuan->id,
                'keperluan' => $request->keperluan,
                    'nomor_telepon' => $request->nomor_telepon
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan surat belum menikah berhasil',
                'data' => [
                    'pengajuan' => $pengajuan,
                    'surat_belum_menikah' => $suratBelumMenikah
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengajukan surat',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function generateDoc($id)
    {
        $pengajuan = pengajuan_surat::with(['resident', 'suratBelumMenikah'])->findOrFail($id);

        $content = "SURAT KETERANGAN BELUM MENIKAH\n\n";
        $content .= "Yang bertanda tangan di bawah ini menerangkan bahwa:\n\n";
        $content .= "Nama: {$pengajuan->resident->name}\n";
        $content .= "NIK: {$pengajuan->resident->nik}\n";
        $content .= "Alamat Asal: {$pengajuan->resident->address}\n";
        $content .= "Keperluan: {$pengajuan->suratBelumMenikah->keperluan}\n\n";
        $content .= "Demikian surat keterangan ini dibuat untuk dipergunakan sebagaimana mestinya.\n\n";
        $content .= "Hormat kami,\n\n\n";
        $content .= "Tanda Tangan\n";
        $content .= "Tanggal: " . now()->format('d-m-Y');

        $filename = 'surat_belum_menikah_' . $pengajuan->id . '.txt';
        $path = storage_path('app/generated/' . $filename);

        // Buat direktori jika belum ada
        if (!file_exists(dirname($path))) {
            mkdir(dirname($path), 0777, true);
        }

        file_put_contents($path, $content);

        return response()->download($path)->deleteFileAfterSend(true);
    }
}
