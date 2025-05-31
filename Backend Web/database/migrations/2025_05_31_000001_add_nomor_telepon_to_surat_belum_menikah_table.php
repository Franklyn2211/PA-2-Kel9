<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('surat_belum_menikah', function (Blueprint $table) {
            $table->string('nomor_telepon')->nullable()->after('keperluan');
        });
    }

    public function down(): void
    {
        Schema::table('surat_belum_menikah', function (Blueprint $table) {
            $table->dropColumn('nomor_telepon');
        });
    }
};
