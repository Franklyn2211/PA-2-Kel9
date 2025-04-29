<?php

namespace Database\Seeders;

use App\Models\surat_templates;
use Illuminate\Database\Seeder;

class SuratTemplateSeeder extends Seeder
{
    public function run()
    {
        surat_templates::updateOrCreate(
            ['jenis_surat' => 'surat_domisili'],
            [
                'nama_surat' => 'Surat Keterangan Domisili',
                'template_path' => 'templates/surat_domisili_template.docx',
                'placeholder_fields' => json_encode([
                    'nama', 'nik', 'alamat', 'alamat_domisili',
                    'sejak_tanggal', 'keperluan', 'tanggal_surat'
                ])
            ]
        );
    }
}