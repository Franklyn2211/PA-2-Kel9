<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $table = 'products';

    protected $fillable = [
        'product_name',
        'description',
        'photo',
        'location',
        'price',
        'stock',
        'phone',
        'umkm_id', // Ensure this field is included
    ];

    public function umkm()
    {
        return $this->belongsTo(Umkm::class);
    }
}
