<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_name',
        'description',
        'photo',
        'location',
        'price',
        'stock',
        'phone',
        'umkm_id',
    ];

    protected $appends = ['photo_url', 'qris_url'];

    public function umkm()
    {
        return $this->belongsTo(Umkm::class, 'umkm_id');
    }

    public function getPhotoUrlAttribute()
    {
        return $this->photo ? asset('storage/'.$this->photo) : null;
    }

    public function getQrisUrlAttribute()
    {
        return optional($this->umkm)->qris_url;
    }
}