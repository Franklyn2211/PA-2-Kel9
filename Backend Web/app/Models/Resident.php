<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens; // Tambahkan ini

class Resident extends Authenticatable
{
    use HasApiTokens, HasFactory; // Tambahkan HasApiTokens

    protected $table = 'resident';

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
