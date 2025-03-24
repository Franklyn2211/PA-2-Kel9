<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Residents extends Model
{
    use HasFactory;

    protected $table = 'residents';

    protected $fillable = [
        'nik',
        'name',
        'gender',
        'address',
        'birth_date',
        'religion',
        'family_card_number',
    ];

    public function getGenderLabelAttribute()
    {
        return $this->gender === 'Male'? 'Laki-laki' : 'Perempuan';
    }
}
