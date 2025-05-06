<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Announcements extends Model
{
    use HasFactory;

    protected $table = 'announcements';

    protected $fillable = [
        'title', 'description', 'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($announcement) {
            if (is_null($announcement->user_id)) {
                $announcement->user_id = 1; // Default value
            }
        });
    }
}
