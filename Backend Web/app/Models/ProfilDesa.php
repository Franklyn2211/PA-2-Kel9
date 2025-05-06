<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProfilDesa extends Model
{
    use HasFactory;

    protected $table = 'village_description';

    protected $fillable = [
        'history',
        'visi',
        'misi',
        'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($profilDesa) {
            if (is_null($profilDesa->user_id)) {
                $profilDesa->user_id = 1; // Default value
            }
        });
    }
}
