<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class surat_templates extends Model
{
    use HasFactory;

    protected $table = 'surat_templates';

    protected $fillable = [
        'jenis_surat',
        'nama_surat',
        'template_path',
        'placeholder_fields'
    ];

    protected $casts = [
        'placeholder_fields' => 'array'
    ];

    // Relasi ke pengajuan surat
    public function pengajuanSurat()
    {
        return $this->hasMany(pengajuan_surat::class, 'template_id');
    }

    // Method untuk mendapatkan path lengkap template
    public function getFullPathAttribute()
    {
        return storage_path('app/' . $this->template_path);
    }
}