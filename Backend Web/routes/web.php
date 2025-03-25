<?php

use App\Http\Controllers\Admin\AnnouncementController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\NewsController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\ResidentsController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\UMKMController;
use Illuminate\Support\Facades\Route;

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

Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

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
    Route::post('/pengumuman', [AnnouncementController::class,'store'])->name('admin.pengumuman.store');
    Route::get('/pengumuman/{announcements}/edit', [AnnouncementController::class, 'edit'])->name('admin.pengumuman.edit');
    Route::put('/pengumuman/{announcements}', [AnnouncementController::class, 'update'])->name('admin.pengumuman.update');
    Route::delete('/pengumuman/{announcements}', [AnnouncementController::class, 'destroy'])->name('admin.pengumuman.destroy');

    // Galeri
    Route::get('/galeri', function () {
        return view('admin.galeri.index');
    })->name('admin.galeri.index');

    // Surat Menyurat
    Route::get('/surat', function () {
        return view('admin.surat.index');
    })->name('admin.surat.index');

    // Aparatur Desa
    Route::get('/aparatur', function () {
        return view('admin.aparatur.index');
    })->name('admin.aparatur.index');

    // Program Desa
    Route::get('/program', function () {
        return view('admin.program.index');
    })->name('admin.program.index');

    // Pembangunan
    Route::get('/pembangunan', function () {
        return view('admin.pembangunan.index');
    })->name('admin.pembangunan.index');

    // Profil Desa
    Route::get('/profil', function () {
        return view('admin.profil.index');
    })->name('admin.profil.index');

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
