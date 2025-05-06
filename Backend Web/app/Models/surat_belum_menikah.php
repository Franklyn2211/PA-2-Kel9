<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class surat_belum_menikah extends Model
{
    use HasFactory;

    protected $table = 'surat_belum_menikah';

    protected $fillable = [
        'pengajuan_id',
        'keperluan',
        'data_tambahan',
    ];

    public function pengajuan()
    {
        return $this->belongsTo(pengajuan_surat::class, 'pengajuan_id');
    }
}
