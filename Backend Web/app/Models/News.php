<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class News extends Model
{
    use HasFactory;

    protected $table = 'news';

    protected $fillable = [
        'title',
        'description',
        'photo',
        'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($news) {
            if (is_null($news->user_id)) {
                $news->user_id = 1; // Default value
            }
        });
    }
}
