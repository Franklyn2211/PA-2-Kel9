<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class surat_domisili extends Model
{
    use HasFactory;

    protected $table = 'surat_domisili';

    protected $fillable = [
        'pengajuan_id',
        'keperluan',
    ];


    public function pengajuan()
    {
        return $this->belongsTo(pengajuan_surat::class, 'pengajuan_id');
    }
}