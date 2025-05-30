<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens; // Tambahkan ini

class Penduduk extends Authenticatable
{
    use HasApiTokens, HasFactory; // Tambahkan HasApiTokens

    protected $table = 'penduduk';
    
    protected $fillable = [
        'nik',
        'name',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];
}