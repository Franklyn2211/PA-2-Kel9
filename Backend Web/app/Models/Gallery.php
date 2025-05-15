<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Gallery extends Model
{
    use HasFactory;

    protected $table = 'galleries';

    protected $fillable = [
        'title',
        'photo',
        'date_taken',
        'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($gallery) {
            if (is_null($gallery->user_id)) {
                $gallery->user_id = 1; // Default value
            }
        });
    }
}
