<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Staff extends Model
{
    use HasFactory;

    protected $table = 'staff';

    protected $fillable = [
        'name',
        'position',
        'photo',
        'email',
        'phone',
        'npsn_active',
        'user_id',
    ];
    protected static function booted()
    {
        static::creating(function ($staff) {
            if (is_null($staff->user_id)) {
                $staff->user_id = 1; // Default value
            }
        });
    }
}
