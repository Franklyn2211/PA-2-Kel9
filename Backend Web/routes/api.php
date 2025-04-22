<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PostController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\API\OrderController;
use App\Http\Controllers\Api\PendudukController;
use App\Http\Controllers\Admin\ResidentsController;

Route::get('/products', [PostController::class, 'getProduct']);
Route::get('/umkm', [PostController::class, 'getUmkm']);
Route::get('/news', [PostController::class, 'getNews']);
Route::get('/pengumuman', [PostController::class, 'getAnnouncements']);
Route::get('/profildesa', [PostController::class, 'getProfilDesa']);
Route::get('/staff', [PostController::class, 'getStaff']);
Route::get('/penduduk', [ResidentsController::class, 'CheckNik']);
Route::get('/pendudukku', [PostController::class, 'getPenduduk']);

Route::post('/register', [PendudukController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/orders', [OrderController::class, 'store']);
