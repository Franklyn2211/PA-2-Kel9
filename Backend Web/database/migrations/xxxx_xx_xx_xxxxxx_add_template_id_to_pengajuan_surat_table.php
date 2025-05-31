public function up()
{
    Schema::table('pengajuan_surat', function (Blueprint $table) {
        $table->unsignedBigInteger('template_id')->after('resident_id');
        $table->foreign('template_id')->references('id')->on('surat_templates')->onDelete('cascade');
    });
}

public function down()
{
    Schema::table('pengajuan_surat', function (Blueprint $table) {
        $table->dropForeign(['template_id']);
        $table->dropColumn('template_id');
    });
}
