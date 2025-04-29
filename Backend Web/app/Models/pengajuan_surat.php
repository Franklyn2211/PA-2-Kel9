<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class pengajuan_surat extends Model
{
    use HasFactory;

    protected $table = 'pengajuan_surat';

    protected $fillable = [
        'resident_id',
        'template_id',
        'nomor_surat',
        'status',
        'catatan_admin',
        'feedback',
        'tanggal_diselesaikan'
    ];

    protected $casts = [
        'tanggal_pengajuan' => 'datetime',
        'tanggal_diselesaikan' => 'datetime'
    ];

    // Status constants
    const STATUS_DRAFT = 'draft';
    const STATUS_DIAJUKAN = 'diajukan';
    const STATUS_DIPROSES = 'diproses';
    const STATUS_DISETUJUI = 'disetujui';
    const STATUS_DITOLAK = 'ditolak';

    // Relasi ke resident
    public function resident()
    {
        return $this->belongsTo(Residents::class, 'resident_id');
    }

    // Relasi ke template
    public function template()
    {
        return $this->belongsTo(surat_templates::class, 'template_id');
    }

    // Scope untuk filter status
    public function scopeByStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    // Method untuk mengecek apakah bisa diedit
    public function canEdit()
    {
        return in_array($this->status, [self::STATUS_DRAFT, self::STATUS_DITOLAK]);
    }
}