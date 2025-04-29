<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('surat_templates', function (Blueprint $table) {
            $table->id();
            $table->string('jenis_surat')->unique(); // Contoh: 'surat_tidak_mampu'
            $table->string('nama_surat'); // Contoh: 'Surat Keterangan Tidak Mampu'
            $table->text('template_path'); // Path ke file template
            $table->text('placeholder_fields'); // JSON field yang bisa diisi otomatis
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('surat_templates_skbpms');
    }
};
