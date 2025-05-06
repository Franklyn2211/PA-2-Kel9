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
        'phone',
        'qris_image',
        'status',
        'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($umkm) {
            if (is_null($umkm->user_id)) {
                $umkm->user_id = 1; // Default value
            }
        });
    }

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'status' => 'boolean',
    ];

    protected $appends = ['qris_url'];

    public function products()
    {
        return $this->hasMany(Product::class, 'umkm_id');
    }

    public function getQrisUrlAttribute()
    {
        if (!$this->qris_image) return null;

        if (filter_var($this->qris_image, FILTER_VALIDATE_URL)) {
            return $this->qris_image;
        }

        return asset('storage/'.$this->qris_image);
    }
}
