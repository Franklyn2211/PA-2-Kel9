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
            $table->string('jenis_surat'); // Menyimpan jenis surat langsung
            $table->enum('status', ['draft', 'diajukan', 'diproses', 'disetujui', 'ditolak'])->default('draft');
            $table->dateTime('tanggal_pengajuan')->useCurrent();
            $table->dateTime('tanggal_diselesaikan')->nullable();
            $table->timestamps();

            $table->foreign('resident_id')->references('id')->on('resident')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pengajuan_surat');
    }
};
