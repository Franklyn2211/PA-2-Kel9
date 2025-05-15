<?php

use App\Http\Controllers\PostController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\ResidentsController;
use App\Http\Controllers\API\PendudukController;
use App\Http\Controllers\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::get('/products', [PostController::class, 'getProduct']);
Route::get('/news', [PostController::class, 'getNews']);

Route::get('/penduduk', [ResidentsController::class, 'CheckNik']);

Route::get('/pengumuman', [PostController::class, 'getAnnouncements']);
Route::post('/register', [PendudukController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);