<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class Orders extends Model
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'penduduk_id',
        'product_id',
        'bukti_transfer',
    ];
    protected $table = 'orders';

    public function penduduk()
    {
        return $this->belongsTo(Penduduk::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
