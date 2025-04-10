<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class UMKM extends Authenticatable
{
    use HasFactory;

    protected $table = 'umkm';
    protected $fillable = [
        'nama_umkm',
        'email',
        'password',
        'phone', // Added phone field
        'status',
    ];
    protected $hidden = [
        'password',
        'remember_token',
    ];
    protected $casts = [
        'status' => 'boolean',
    ];

    public function products()
    {
        return $this->hasMany(Product::class, 'umkm_id'); // Define relationship
    }
}
