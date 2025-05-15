<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\pengajuan_surat;
use App\Models\Residents;
use App\Models\surat_domisili;
use App\Models\surat_templates;
use App\Models\SuratTemplate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SuratDomisiliController extends Controller
{
    public function store(Request $request)
    {
        // Log data yang diterima
        \Log::info('Data diterima untuk pengajuan surat domisili:', $request->all());

        $request->validate([
            'resident_id' => 'required|exists:residents,id',
            'keperluan' => 'required',
            'nomor_telepon' => 'required', // Pastikan ini sesuai dengan data dari frontend
        ]);

        DB::beginTransaction();

        try {
            // Cari template surat domisili
            $template = surat_templates::where('jenis_surat', 'surat domisili')->first();
            
            if (!$template) {
                return response()->json([
                    'success' => false,
                    'message' => 'Template surat domisili belum tersedia. Silakan hubungi admin untuk menambahkan template.',
                ], 400);
            }

            // Buat pengajuan umum
            $pengajuan = pengajuan_surat::create([
                'resident_id' => $request->resident_id,
                'template_id' => $template->id,
                'status' => 'diajukan'
            ]);

            // Buat data khusus surat domisili
            $suratDomisili = surat_domisili::create([
                'pengajuan_id' => $pengajuan->id,
                'keperluan' => $request->keperluan,
                'data_tambahan' => json_encode([
                    'nomor_telepon' => $request->nomor_telepon
                ])
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pengajuan surat domisili berhasil',
                'data' => [
                    'pengajuan' => $pengajuan,
                    'surat_domisili' => $suratDomisili
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error saat mengajukan surat domisili:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengajukan surat',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function generateDoc($id)
    {
        $pengajuan = pengajuan_surat::with(['resident', 'suratDomisili'])->findOrFail($id);

        $content = "SURAT KETERANGAN DOMISILI\n\n";
        $content .= "Yang bertanda tangan di bawah ini menerangkan bahwa:\n\n";
        $content .= "Nama: {$pengajuan->resident->name}\n";
        $content .= "NIK: {$pengajuan->resident->nik}\n";
        $content .= "Alamat Asal: {$pengajuan->resident->address}\n";
        $content .= "Keperluan: {$pengajuan->suratDomisili->keperluan}\n\n";
        $content .= "Demikian surat keterangan ini dibuat untuk dipergunakan sebagaimana mestinya.\n\n";
        $content .= "Hormat kami,\n\n\n";
        $content .= "Tanda Tangan\n";
        $content .= "Tanggal: " . now()->format('d-m-Y');

        $filename = 'surat_domisili_' . $pengajuan->id . '.txt';
        $path = storage_path('app/generated/' . $filename);
        
        // Buat direktori jika belum ada
        if (!file_exists(dirname($path))) {
            mkdir(dirname($path), 0777, true);
        }
        
        file_put_contents($path, $content);

        return response()->download($path)->deleteFileAfterSend(true);
    }
}