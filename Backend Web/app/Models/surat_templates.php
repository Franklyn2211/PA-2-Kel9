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
        'user_id',
    ];
    // Relasi ke pengajuan surat
    public function pengajuanSurat()
    {
        return $this->hasMany(pengajuan_surat::class, 'template_id');
    }

    protected static function booted()
    {
        static::creating(function ($template) {
            if (is_null($template->user_id)) {
                $template->user_id = 1; // Default value
            }
        });
    }
}
