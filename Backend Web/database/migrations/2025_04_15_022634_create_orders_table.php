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
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('penduduk_id'); // relasi ke penduduk yang login
            $table->unsignedBigInteger('product_id');
            $table->string('bukti_transfer')->nullable(); // path ke file bukti transfer
            $table->timestamps();

            $table->foreign('penduduk_id')->references('id')->on('penduduk')->onDelete('cascade');
            $table->foreign('product_id')->references('id')->on('products')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
