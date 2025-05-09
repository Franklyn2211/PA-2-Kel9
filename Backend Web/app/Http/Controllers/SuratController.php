<?php

namespace App\Http\Controllers;

use App\Models\pengajuan_surat;
use App\Models\Residents;
use App\Models\surat_belum_menikah;
use Illuminate\Http\Request;
use PhpOffice\PhpWord\TemplateProcessor; // Ensure this library is installed via Composer
use Barryvdh\DomPDF\Facade\Pdf;

class SuratController extends Controller
{
    // Dashboard admin
    public function index()
    {
        $pengajuan = pengajuan_surat::with(['resident', 'template'])->orderBy('created_at', 'desc')->get();

        return view('admin.pengajuan.index', compact('pengajuan'));
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
                $detailPengajuan = surat_belum_menikah::where('pengajuan_id', $id)->first();
                break;

            // Tambahkan case untuk jenis surat lainnya
        }

        return view('admin.pengajuan.detail', compact('pengajuan', 'detailPengajuan'));
    }

    public function destroy($id)
    {
        $pengajuan = pengajuan_surat::findOrFail($id);
        $pengajuan->delete();

        return redirect()->route('admin.pengajuan.index')->with('success', 'Pengajuan berhasil dihapus.');
    }

    public function approve($id)
    {
        $pengajuan = pengajuan_surat::findOrFail($id);
        $pengajuan->status = 'disetujui';
        $pengajuan->tanggal_diselesaikan = now()->timezone('Asia/Jakarta'); // Set the completion time to the current time
        $pengajuan->save();

        return redirect()->route('admin.pengajuan.index')->with('success', 'Pengajuan berhasil disetujui.');
    }

    public function generateAndShowPDF($id)
    {
        try {
            // [1] Ambil data pengajuan
            \Log::info("Memulai proses generate PDF untuk pengajuan ID: $id");
            $pengajuan = pengajuan_surat::with(['resident', 'template'])->findOrFail($id);

            // [2] Validasi data resident
            if (!$pengajuan->resident) {
                \Log::error("Data penduduk tidak ditemukan untuk pengajuan ID: $id");
                throw new \Exception("Data penduduk tidak ditemukan untuk pengajuan ini.");
            }

            // [3] Tentukan template berdasarkan jenis surat
            $jenisSurat = strtolower(trim($pengajuan->template->jenis_surat));
            \Log::info("Jenis surat: $jenisSurat");
            $viewName = match ($jenisSurat) {
                'surat domisili' => 'templates.surat_domisili',
                'surat belum menikah' => 'templates.surat_belum_menikah',
                default => throw new \Exception("Template untuk jenis surat '$jenisSurat' tidak ditemukan."),
            };

            // [4] Siapkan data untuk template
            $data = [
                'nama' => $pengajuan->resident->name ?? '[Nama Kosong]',
                'nik' => $pengajuan->resident->nik ?? '[NIK Kosong]',
                'alamat' => $pengajuan->resident->address ?? '[Alamat Kosong]',
                'gender' => $pengajuan->resident->gender ?? '[Jenis Kelamin Kosong]',
                'birth_date' => $pengajuan->resident->birth_date ?? '[Tanggal Lahir Kosong]',
                'religion' => $pengajuan->resident->religion ?? '[Agama Kosong]',
                'tanggal_surat' => now()->locale('id')->isoFormat('D MMMM YYYY'),
                'logo_base64' => 'data:image/jpeg;base64,' . base64_encode(file_get_contents(public_path('media/image1.jpeg'))),
            ];
            \Log::info("Data untuk template berhasil disiapkan.", $data);

            // [5] Render template HTML ke PDF
            \Log::info("Mulai proses rendering PDF.");
            $pdf = Pdf::loadView($viewName, $data);

            // [6] Unduh file PDF
            \Log::info("PDF berhasil dirender, mengunduh file.");
            return $pdf->stream('surat_' . time() . '.pdf');

        } catch (\Exception $e) {
            // Log error untuk debugging
            \Log::error('Gagal generate PDF: ' . $e->getMessage());
            return back()->with('error', 'Gagal generate PDF: ' . $e->getMessage());
        }
    }
}