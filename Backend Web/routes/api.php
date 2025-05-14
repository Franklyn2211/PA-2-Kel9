<?php

use App\Http\Controllers\Api\SuratDomisiliController;
use App\Http\Controllers\Api\SuratBelumMenikahController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PostController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\API\OrderController;
use App\Http\Controllers\Api\PendudukController;
use App\Http\Controllers\Admin\ResidentsController;
use App\Http\Controllers\SuratController;

Route::get('/products', [PostController::class, 'getProduct']);
Route::get('/products/{id}', [PostController::class, 'getProductById']);
Route::get('/umkm', [PostController::class, 'getUmkm']);
Route::get('/news', [PostController::class, 'getNews']);
Route::get('/pengumuman', [PostController::class, 'getAnnouncements']);
Route::get('/profildesa', [PostController::class, 'getProfilDesa']);
Route::get('/staff', [PostController::class, 'getStaff']);
Route::get('/galeri', [PostController::class, 'getGallery']);
Route::get('/resident', [ResidentsController::class, 'CheckNik']);
Route::get('/pendudukku', [PostController::class, 'getResidents']);

Route::post('/register', [PendudukController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/orders', [OrderController::class, 'store']);
Route::post('/user/requests', [SuratController::class, 'getUserRequests']); // Rute untuk daftar pengajuan surat
Route::post('/pengajuan/surat-domisili', [SuratDomisiliController::class, 'store']);
Route::post('/pengajuan/belum-menikah', [SuratBelumMenikahController::class, 'store']);

// Rute untuk mendapatkan daftar request surat user
Route::middleware('auth:sanctum')->get('/user/requests', function () {
    \Log::info("Route /user/requests accessed"); // Debug log
    return app(\App\Http\Controllers\SuratController::class)->getUserRequests(request());
});
Route::get('/orders', [OrderController::class, 'getUserOrders']);
Route::get('/pengajuan/{id}/download', [SuratController::class, 'downloadPDF']); // Rute untuk mengunduh PDF
