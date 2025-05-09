<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Surat Keterangan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .content {
            margin: 0 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Surat Keterangan</h1>
    </div>
    <div class="content">
        <p>Yang bertanda tangan di bawah ini:</p>
        <p>Nama: {{ $nama }}</p>
        <p>NIK: {{ $nik }}</p>
        <p>Alamat: {{ $alamat }}</p>
        <p>Menyatakan bahwa yang bersangkutan benar-benar belum Menikah di alamat tersebut.</p>
        <p>Tanggal Surat: {{ $tanggal_surat }}</p>
    </div>
</body>
</html>
