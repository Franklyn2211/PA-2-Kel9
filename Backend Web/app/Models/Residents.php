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

    protected $casts = [
        'birth_date' => 'date:Y-m-d',
    ];

    protected $appends = [
        'gender_label',
        'age'
    ];

    public function getGenderLabelAttribute()
    {
        if ($this->gender === null) return 'Belum diisi';
        return $this->gender === 'Male' ? 'Laki-laki' : 'Perempuan';
    }

    public function getAgeAttribute()
    {
        return $this->birth_date?->age ?? 'Belum diisi';
    }
}