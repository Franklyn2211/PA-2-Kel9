<?php

use App\Http\Controllers\Admin\AnnouncementController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\GalleryController;
use App\Http\Controllers\Admin\NewsController;
use App\Http\Controllers\Admin\ProfilDesaController;
use App\Http\Controllers\Admin\StaffController;
use App\Http\Controllers\SuratController;
use App\Http\Controllers\UMKM\ProductController;
use App\Http\Controllers\Admin\ResidentsController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\UMKMController;
use App\Http\Controllers\Auth\PengajuanSuratController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;


/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/login', [LoginController::class, 'showLoginForm'])->name('login');
Route::get('/register/umkm', [UMKMController::class, 'showRegisterForm'])->name('register');
Route::post('/register/umkm', [UMKMController::class, 'register'])->name('register.umkm.post');
Route::get('/login/umkm', [UMKMController::class, 'showLoginForm'])->name('login.umkm');
Route::post('/login/umkm', [UMKMController::class, 'login'])->name('login.umkm.post');
Route::post('/logout/umkm', [UMKMController::class, 'logout'])->name('logout.umkm');

Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

// Add a route to clear the session flag after the popup is displayed
Route::post('/clear-just-logged-in', function (Request $request) {
    $request->session()->forget('just_logged_in'); // Clear the session flag
    return response()->noContent();
})->name('clear.just_logged_in');

// Umkm Routes
Route::prefix('umkm')->middleware('auth:umkm')->group(function () {
    Route::get('/', [\App\Http\Controllers\UMKM\DashboardController::class, 'index'])->name('umkm.dashboard');
    Route::get('/umkm/dashboard', [\App\Http\Controllers\UMKM\DashboardController::class, 'index'])->name('umkm.dashboard.index');

    // Other UMKM routes
    Route::get('/products', [ProductController::class, 'index'])->name('umkm.products.index');
    Route::get('/products/create', [ProductController::class, 'create'])->name('umkm.products.create');
    Route::post('/products', [ProductController::class, 'store'])->name('umkm.products.store');
    Route::get('/products/{products}/edit', [ProductController::class, 'edit'])->name('umkm.products.edit');
    Route::put('/products/{products}', [ProductController::class, 'update'])->name('umkm.products.update');
    Route::delete('/products/{products}', [ProductController::class, 'destroy'])->name('umkm.products.destroy');

    Route::get('/orders', [\App\Http\Controllers\UMKM\OrderController::class, 'index'])->name('umkm.order.index');
    Route::patch('/orders/{id}/status', [\App\Http\Controllers\UMKM\OrderController::class, 'updateStatus'])->name('umkm.order.status');

    Route::get('/profil', function () {
        return view('umkm.profil');
    })->name('umkm.profil');

    Route::post('/profil/qris', [UMKMController::class, 'updateQRIS'])->name('umkm.qris.update');

    // Add routes for editing and updating the UMKM profile
    Route::get('/profil/edit', [UMKMController::class, 'edit'])->name('umkm.profil.edit');
    Route::put('/profil', [UMKMController::class, 'update'])->name('umkm.profil.update');
});

// Admin Routes
Route::prefix('admin')->middleware('auth')->group(function () {
    // Dashboard
    Route::get('/', [DashboardController::class, 'index'])->name('admin.dashboard');
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('admin.dashboard.index');

    // Other admin routes
    // Penduduk
    Route::get('/penduduk', [ResidentsController::class, 'index'])->name('admin.penduduk.index');
    Route::get('/penduduk/create', [ResidentsController::class, 'create'])->name('admin.penduduk.create');
    Route::post('/penduduk', [ResidentsController::class, 'store'])->name('admin.penduduk.store');
    Route::get('/penduduk/{residents}/edit', [ResidentsController::class, 'edit'])->name('admin.penduduk.edit');
    Route::put('/penduduk/{residents}', [ResidentsController::class, 'update'])->name('admin.penduduk.update');
    Route::delete('/penduduk/{residents}', [ResidentsController::class, 'destroy'])->name('admin.penduduk.destroy');

    // Layanan
    Route::get('/layanan', [ProductController::class, 'index'])->name('admin.layanan.index');
    Route::get('/layanan/create', [ProductController::class, 'create'])->name('admin.layanan.create');
    Route::post('/layanan', [ProductController::class, 'store'])->name('admin.layanan.store');
    Route::get('/layanan/{products}/edit', [ProductController::class, 'edit'])->name('admin.layanan.edit');
    Route::put('/layanan/{products}', [ProductController::class, 'update'])->name('admin.layanan.update');
    Route::delete('/layanan/{products}', [ProductController::class, 'destroy'])->name('admin.layanan.destroy');

    // Berita
    Route::get('/berita', [NewsController::class, 'index'])->name('admin.berita.index');
    Route::get('/berita/create', [NewsController::class, 'create'])->name('admin.berita.create');
    Route::post('/berita', [NewsController::class, 'store'])->name('admin.berita.store');
    Route::get('/berita/{news}/edit', [NewsController::class, 'edit'])->name('admin.berita.edit');
    Route::put('/berita/{news}', [NewsController::class, 'update'])->name('admin.berita.update');
    Route::delete('/berita/{news}', [NewsController::class, 'destroy'])->name('admin.berita.destroy');

    // Pengumuman
    Route::get('/pengumuman', [AnnouncementController::class, 'index'])->name('admin.pengumuman.index');
    Route::get('/pengumuman/create', [AnnouncementController::class, 'create'])->name('admin.pengumuman.create');
    Route::post('/pengumuman', [AnnouncementController::class, 'store'])->name('admin.pengumuman.store');
    Route::get('/pengumuman/{announcements}/edit', [AnnouncementController::class, 'edit'])->name('admin.pengumuman.edit');
    Route::put('/pengumuman/{announcements}', [AnnouncementController::class, 'update'])->name('admin.pengumuman.update');
    Route::delete('/pengumuman/{announcements}', [AnnouncementController::class, 'destroy'])->name('admin.pengumuman.destroy');

    // Routes untuk warga
Route::middleware(['auth'])->group(function () {
    Route::get('/pengajuan/{jenis}', [PengajuanSuratController::class, 'create']);
    Route::post('/pengajuan', [PengajuanSuratController::class, 'store']);
    Route::get('/pengajuan/detail/{id}', [PengajuanSuratController::class, 'show']);
});

// Routes untuk admin
Route::middleware(['auth', 'admin'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [SuratController::class, 'dashboard']);
    Route::get('/pengajuan', [SuratController::class, 'pengajuan']);
    Route::get('/pengajuan/{id}', [SuratController::class, 'detailPengajuan']);
    Route::post('/pengajuan/approve/{id}', [PengajuanSuratController::class, 'approve']);
    Route::post('/pengajuan/reject/{id}', [PengajuanSuratController::class, 'reject']);
    
    // Routes untuk manajemen template
    Route::resource('templates', SuratTemplateController::class);
});

    // UMKM
    Route::get('/umkm', [\App\Http\Controllers\Admin\UmkmController::class, 'index'])->name('admin.umkm.index');
    Route::patch('/umkm/{id}/status', [\App\Http\Controllers\Admin\UmkmController::class, 'updateStatus'])->name('admin.umkm.updateStatus');

    // Galeri
    Route::get('/galeri', [GalleryController::class, 'index'])->name('admin.galeri.index');
    Route::get('/galeri/create', [GalleryController::class, 'create'])->name('admin.galeri.create');
    Route::post('/galeri', [GalleryController::class, 'store'])->name('admin.galeri.store');
    Route::get('/galeri/{galleries}/edit', [GalleryController::class, 'edit'])->name('admin.galeri.edit');
    Route::put('/galeri/{galleries}', [GalleryController::class, 'update'])->name('admin.galeri.update');
    Route::delete('/galeri/{galleries}', [GalleryController::class, 'destroy'])->name('admin.galeri.destroy');

    // Surat Menyurat
    Route::get('/surat', function () {
        return view('admin.surat.index');
    })->name('admin.surat.index');
    Route::get('/admin/surat', [PengajuanSuratController::class, 'index'])->name('admin.surat.index');

    // Staff
    Route::get('/staff', [StaffController::class, 'index'])->name('admin.staff.index');
    Route::get('/staff/create', [StaffController::class, 'create'])->name('admin.staff.create');
    Route::post('/staff', [StaffController::class, 'store'])->name('admin.staff.store');
    Route::get('/staff/{staff}/edit', [StaffController::class, 'edit'])->name('admin.staff.edit');
    Route::put('/staff/{staff}', [StaffController::class, 'update'])->name('admin.staff.update');
    Route::delete('/staff/{staff}', [StaffController::class, 'destroy'])->name('admin.staff.destroy');

    // Program Desa
    Route::get('/program', function () {
        return view('admin.program.index');
    })->name('admin.program.index');

    // Pembangunan
    Route::get('/pembangunan', function () {
        return view('admin.pembangunan.index');
    })->name('admin.pembangunan.index');

    // Profil Desa
    Route::get('/profildesa', [ProfilDesaController::class, 'index'])->name('admin.profildesa.index');
    Route::get('/profildesa/create', [ProfilDesaController::class, 'create'])->name('admin.profildesa.create');
    Route::post('/profildesa', [ProfilDesaController::class, 'store'])->name('admin.profildesa.store');
    Route::get('/profildesa/{profilDesa}/edit', [ProfilDesaController::class, 'edit'])->name('admin.profildesa.edit');
    Route::put('/profildesa/{profilDesa}', [ProfilDesaController::class, 'update'])->name('admin.profildesa.update');
    Route::delete('/profildesa/{profilDesa}', [ProfilDesaController::class, 'destroy'])->name('admin.profildesa.destroy');

    // Pengguna
    Route::get('/users', function () {
        return view('admin.users.index');
    })->name('admin.users.index');

    // Pengaturan
    Route::get('/settings', function () {
        return view('admin.settings.index');
    })->name('admin.settings.index');
});

// Redirect root to admin dashboard if authenticated
Route::get('/', function () {
    return redirect()->route('admin.dashboard');
});
