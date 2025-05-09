<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class Order extends Model
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'penduduk_id',
        'product_id',
        'bukti_transfer',
        'amount',
        'note',
        'status'
    ];
    protected $table = 'orders';

    protected $casts = [
        'status' => 'boolean',
    ];

    public function penduduk()
    {
        return $this->belongsTo(Resident::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
