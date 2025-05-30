<?php

namespace App\Http\Controllers;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;
use App\Models\pengajuan_surat;
use App\Models\Residents;
use App\Models\surat_belum_menikah;
use Illuminate\Http\Request;
use Illuminate\Notifications\Notification;
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
        $pengajuan = pengajuan_surat::with('resident')->findOrFail($id);
        $pengajuan->status = 'disetujui';
        $pengajuan->tanggal_diselesaikan = now()->timezone('Asia/Jakarta');
        $pengajuan->save();

        // Kirim notifikasi FCM jika user punya fcm_token
        $resident = $pengajuan->resident;
        if ($resident && !empty($resident->fcm_token)) {
            $this->sendFcmNotification(
                $resident->fcm_token,
                'Pengajuan Surat Disetujui',
                'Pengajuan surat Anda telah disetujui.'
            );
        }

        return redirect()->route('admin.pengajuan.index')->with('success', 'Pengajuan berhasil disetujui.');
    }

    /**
     * Kirim notifikasi FCM ke user
     */
    protected function sendFcmNotification($fcmToken, $title, $body)
    {
        $factory = (new Factory)
            ->withServiceAccount(base_path(env('FCM_SERVICE_ACCOUNT_JSON')));

        $messaging = $factory->createMessaging();

        $message = CloudMessage::withTarget('token', $fcmToken)
            ->withNotification(FirebaseNotification::create($title, $body))
            ->withData([
                'type' => 'approval',
            ]);

        try {
            $messaging->send($message);
            \Log::info('✅ FCM sent successfully to ' . $fcmToken);
        } catch (\Throwable $e) {
            \Log::error('❌ FCM send failed: ' . $e->getMessage());
        }
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
                'surat domisili' => 'admin.templates.surat_domisili',
                'surat belum menikah' => 'admin.templates.surat_belum_menikah',
                default => throw new \Exception("Template untuk jenis surat '$jenisSurat' tidak ditemukan."),
            };

            // [4] Siapkan data untuk template
            $data = [
                'nama' => $pengajuan->resident->name ?? '[Nama Kosong]',
                'nik' => $pengajuan->resident->nik ?? '[NIK Kosong]',
                'alamat' => $pengajuan->resident->address ?? '[Alamat Kosong]',
                'gender' => $pengajuan->resident->gender ?? '[Jenis Kelamin Kosong]',
                'family_card_number' => $pengajuan->resident->family_card_number ?? '[Jenis Kelamin Kosong]',
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

    public function getUserRequests(Request $request)
    {
        $userId = $request->input('user_id'); // Ambil ID user dari request
        \Log::info("Fetching requests for user ID: $userId"); // Debug log

        $pengajuan = pengajuan_surat::with(['template'])
            ->where('resident_id', $userId) // Filter berdasarkan ID user
            ->orderBy('created_at', 'desc')
            ->get();

        if ($pengajuan->isEmpty()) {
            \Log::warning("No requests found for user ID: $userId");
        }

        \Log::info("Requests fetched: ", $pengajuan->toArray()); // Debug log

        return response()->json($pengajuan);
    }

    public function downloadPDF($id)
    {
        try {
            $pengajuan = pengajuan_surat::with(['template', 'resident'])->findOrFail($id);

            if ($pengajuan->status !== 'disetujui') {
                return response()->json(['error' => 'Surat belum disetujui'], 403);
            }

            $jenisSurat = strtolower(trim($pengajuan->template->jenis_surat));
            $viewName = match ($jenisSurat) {
                'surat domisili' => 'admin.templates.surat_domisili',
                'surat belum menikah' => 'admin.templates.surat_belum_menikah',
                default => throw new \Exception("Template untuk jenis surat '$jenisSurat' tidak ditemukan."),
            };

            $logoPath = public_path('media/image1.jpeg'); // Path ke logo
            if (!file_exists($logoPath)) {
                throw new \Exception("Logo tidak ditemukan di path: $logoPath");
            }

            $data = [
                'nama' => $pengajuan->resident->name,
                'nik' => $pengajuan->resident->nik,
                'alamat' => $pengajuan->resident->address,
                'gender' => $pengajuan->resident->gender,
                'birth_date' => $pengajuan->resident->birth_date,
                'religion' => $pengajuan->resident->religion,
                'family_card_number' => $pengajuan->resident->family_card_number,
                'tanggal_surat' => now()->locale('id')->isoFormat('D MMMM YYYY'),
                'logo_base64' => 'data:image/jpeg;base64,' . base64_encode(file_get_contents($logoPath)),
            ];

            $pdf = Pdf::loadView($viewName, $data);

            // Gunakan jenis surat sebagai nama file
            $fileName = 'surat_' . str_replace(' ', '_', $jenisSurat) . '_' . $pengajuan->resident->name . '.pdf';

            \Log::info("PDF berhasil dibuat untuk pengajuan ID: $id dengan nama file: $fileName"); // Debug log
            return $pdf->download($fileName);
        } catch (\Exception $e) {
            \Log::error("Gagal membuat PDF untuk pengajuan ID: $id - " . $e->getMessage());
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function saveFcmToken(Request $request)
    {
        \Log::info('Save FCM Token called', $request->all());

        $request->validate([
            'user_id' => 'required|exists:residents,id',
            'fcm_token' => 'required|string',
        ]);

        $resident = \App\Models\Residents::find($request->user_id);
        $resident->fcm_token = $request->fcm_token;
        $resident->save();

        return response()->json(['success' => true, 'message' => 'FCM token berhasil disimpan']);
    }
}
