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
        Schema::create('pengajuan_surat', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('resident_id');
            $table->unsignedBigInteger('template_id');
            $table->string('nomor_surat')->nullable();
            $table->enum('status', ['draft', 'diajukan', 'diproses', 'disetujui', 'ditolak'])->default('draft');
            $table->text('catatan_admin')->nullable();
            $table->text('feedback')->nullable();
            $table->dateTime('tanggal_pengajuan')->useCurrent();
            $table->dateTime('tanggal_diselesaikan')->nullable();
            $table->timestamps();
            
            $table->foreign('resident_id')->references('id')->on('residents')->onDelete('cascade');
            $table->foreign('template_id')->references('id')->on('surat_templates')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pengajuan_surats');
    }
};
