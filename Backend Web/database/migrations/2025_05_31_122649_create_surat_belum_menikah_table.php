<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('surat_belum_menikah', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('pengajuan_id');
            $table->text('keperluan');
            $table->json('data_tambahan')->nullable(); // Ubah dari binary ke json
            $table->timestamps();
            $table->foreign('pengajuan_id')->references('id')->on('pengajuan_surat')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('surat_belum_menikah');
    }
};
