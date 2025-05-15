<?php

namespace App\Http\Controllers;

use App\Models\Residents;
use App\Models\pengajuan_surat;
use App\Models\surat_templates;
use App\Models\SuratTemplate;
use App\Models\surat_tidak_mampu; // Contoh jenis surat khusus
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use PhpOffice\PhpWord\TemplateProcessor;
use Illuminate\Support\Facades\DB; // Tambahkan jika belum ada

class PengajuanSuratController extends Controller
{
    // Menampilkan form pengajuan baru
    public function create($jenisSurat)
    {
        $template = surat_templates::where('jenis_surat', $jenisSurat)->firstOrFail();
        return view('pengajuan.create', compact('template'));
    }

    // Menyimpan pengajuan baru
    public function store(Request $request)
    {
        $request->validate([
            'resident_id' => 'required|exists:residents,id',
            'jenis_surat' => 'required|exists:surat_templates,jenis_surat',
            // Tambahkan validasi sesuai kebutuhan
        ]);

        // Mulai transaction
        DB::beginTransaction();

        try {
            // Simpan data pengajuan umum
            $template = surat_templates::where('jenis_surat', $request->jenis_surat)->first();

            $pengajuan = pengajuan_surat::create([
                'resident_id' => $request->resident_id,
                'template_id' => $template->id,
                'status' => 'diajukan',
            ]);

            // Simpan data khusus berdasarkan jenis surat
            switch ($request->jenis_surat) {
                case 'surat_tidak_mampu':
                    surat_tidak_mampu::create([
                        'pengajuan_id' => $pengajuan->id,
                        'alasan_pengajuan' => $request->alasan_pengajuan,
                        'nomor_telepon' => $request->nomor_telepon,
                        'alamat_sekarang' => $request->alamat_sekarang,
                    ]);
                    break;

                // Tambahkan case untuk jenis surat lainnya

                default:
                    throw new \Exception("Jenis surat tidak dikenali");
            }

            DB::commit();

            return redirect()->route('pengajuan.show', $pengajuan->id)
                ->with('success', 'Pengajuan berhasil dikirim');

        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Gagal mengajukan surat: ' . $e->getMessage());
        }
    }

    // Menampilkan detail pengajuan
    public function show($id)
    {
        $pengajuan = pengajuan_surat::with(['resident', 'template'])->findOrFail($id);

        // Debugging untuk memastikan data pengajuan
        if (!$pengajuan) {
            abort(404, 'Pengajuan tidak ditemukan'); // Ganti dd dengan abort
        }

        // Ambil data khusus berdasarkan jenis surat
        $detailPengajuan = null;
        switch ($pengajuan->template->jenis_surat) {
            case 'surat_tidak_mampu':
                $detailPengajuan = surat_tidak_mampu::where('pengajuan_id', $id)->first();
                break;

            // Tambahkan case untuk jenis surat lainnya
        }

        // Debugging untuk memastikan data detail pengajuan
        if (!$detailPengajuan) {
            abort(404, 'Detail pengajuan tidak ditemukan'); // Ganti dd dengan abort
        }

        return view('admin.surat.index', compact('pengajuan', 'detailPengajuan'));
    }

    // Approve pengajuan oleh admin
    public function approve($id)
    {
        $pengajuan = pengajuan_surat::with(['template', 'resident'])->findOrFail($id);

        // Generate nomor surat
        $pengajuan->nomor_surat = $this->generateNomorSurat($pengajuan);
        $pengajuan->status = 'disetujui';
        $pengajuan->tanggal_diselesaikan = now();
        $pengajuan->save();

        // Generate dokumen
        $documentPath = $this->generateDocument($pengajuan);

        return response()->download(storage_path('app/' . $documentPath));
    }

    // Menolak pengajuan
    public function reject(Request $request, $id)
    {
        $request->validate(['feedback' => 'required|string']);

        $pengajuan = pengajuan_surat::findOrFail($id);
        $pengajuan->status = 'ditolak';
        $pengajuan->feedback = $request->feedback;
        $pengajuan->save();

        return back()->with('success', 'Pengajuan telah ditolak');
    }
    // Generate nomor surat
    private function generateNomorSurat($pengajuan)
    {
        $count = pengajuan_surat::where('template_id', $pengajuan->template_id)
            ->whereYear('created_at', date('Y'))
            ->count();

        $kodeSurat = [
            'surat_tidak_mampu' => 'STM',
            'surat_domisili' => 'SDM',
            // Tambahkan kode untuk jenis surat lainnya
        ];

        return sprintf('%s/%03d/%s/%d',
            $kodeSurat[$pengajuan->template->jenis_surat],
            $count + 1,
            romanNumerals(date('n')),
            date('Y')
        );
    }

    // Generate dokumen dari template
    private function generateDocument($pengajuan)
    {
        $templatePath = storage_path('app/' . $pengajuan->template->template_path);
        $template = new TemplateProcessor($templatePath);

        // Isi data umum
        $template->setValue('nomor_surat', $pengajuan->nomor_surat);
        $template->setValue('tanggal_surat', now()->format('d F Y'));

        // Isi data penduduk
        $template->setValue('nama', $pengajuan->resident->name);
        $template->setValue('nik', $pengajuan->resident->nik);
        $template->setValue('alamat', $pengajuan->resident->address);
        // ... tambahkan field lainnya

        // Isi data khusus pengajuan
        switch ($pengajuan->template->jenis_surat) {
            case 'surat_tidak_mampu':
                $detail = surat_tidak_mampu::where('pengajuan_id', $pengajuan->id)->first();
                $template->setValue('alasan_pengajuan', $detail->alasan_pengajuan);
                $template->setValue('nomor_telepon', $detail->nomor_telepon);
                break;

            // Tambahkan case untuk jenis surat lainnya
        }

        $filename = 'surat_' . $pengajuan->id . '.docx';
        $path = 'surat/' . $filename;
        $template->saveAs(storage_path('app/' . $path));

        return $path;
    }
}
