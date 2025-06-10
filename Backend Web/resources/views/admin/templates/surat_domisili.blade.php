<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Surat Keterangan Domisili</title>
    <style>
        body {
            font-family: 'Times New Roman', Times, serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            color: #000;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
        }

        .header {
            text-align: center;
            margin-bottom: 10px;
            border-bottom: 3px solid #000;
            padding-bottom: 20px;
            position: relative;
        }

        .logo {
            position: absolute;
            left: 0;
            top: 0;
            width: 80px;
            height: auto;
        }

        .pemerintah {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .kecamatan {
            font-size: 14px;
            margin-bottom: 5px;
        }

        .desa {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .alamat {
            margin-bottom: 10px;
            font-size: 12px;
        }

        .judul {
            text-align: center;
            font-weight: bold;
            text-decoration: underline;
            font-size: 18px;
        }

        .nomor {
            text-align: center;
            font-size: 14px;
        }

        .content {
            text-align: justify;
        }

        .form-data {
            margin: 20px 0 30px 30px;
        }

        .form-field {
            margin-bottom: 10px;
            display: flex;
        }

        .form-field label {
            flex: 0 0 150px;
        }

        .form-field span {
            flex: 6;
            padding-left: 10px;
            /* Tambahkan jarak antara titik dua dan teks */
        }

        .ttd {
            float: right;
            width: 250px;
            text-align: center;
        }

        .ttd p {
            margin: 3px 0;
        }

        .kepala-desa {
            font-weight: bold;
            text-decoration: underline;
        }

        .clearfix::after {
            content: "";
            clear: both;
            display: table;
        }

        @media print {
            .container {
                border: none;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <img src="{{ $logo_base64 }}" alt="Logo Kabupaten Samosir" class="logo">
            <div class="pemerintah">PEMERINTAH KABUPATEN SAMOSIR</div>
            <div class="kecamatan">KECAMATAN SIMANINDO</div>
            <div class="desa">DESA AMBARITA</div>
            <div class="alamat">Jalan Raya Ambarita Kode Pos 22395 Email: desaambaritaku@gmail.com</div>
        </div>

        <div class="judul">SURAT KETERANGAN DOMISILI</div>

        <div class="nomor">Nomor: ______/SKD/BA/II/2025</div>

        <div class="content">
            <p>Yang bertanda tangan di bawah ini Kepala Desa Ambarita Kecamatan Simanindo Kabupaten Samosir menerangkan
                bahwa:</p>

            <div class="form-data">
                <div class="form-field">
                    <label>Nama</label>
                    <span style="margin-left: 51px;">: {{ $nama }}</span>
                </div>
                <div class="form-field">
                    <label>Jenis Kelamin</label>
                    <span>: {{ $gender ?? 'Tidak Diketahui' }}</span>
                </div>
                <div class="form-field">
                    <label>NIK</label>
                    <span style="margin-left: 62px;">: {{ $nik }}</span>
                </div>
                <div class="form-field">
                    <label>Tgl Lahir</label>
                    <span style="margin-left: 30px;">: {{ $birth_date ?? 'Tidak Diketahui' }}</span>
                </div>
                <div class="form-field">
                    <label>Agama</label>
                    <span style="margin-left: 45px;">: {{ $religion }}</span>
                </div>
                <div class="form-field">
                    <label>Alamat</label>
                    <span style="margin-left: 45px;">: {{ $alamat }}</span>
                </div>
            </div>

            <p>adalah benar telah melaporkan diri dan tercatat sebagai penduduk Sementara di Dusun I(Satu) Kampung
                Kristen Labuhan Desa Ambarita Kecamatan Simanindo Kabupaten Samosir Provinsi Sumatera Utara. Surat
                Keterangan ini berlaku selama <strong>6(Enam) bulan</strong> sejak tanggal diterbitkan.</p>

            <p>Demikian Surat Keterangan ini dibuat dan diberikan pada yang bersangkutan untuk dapat dipergunakan
                seperlunya.</p>
        </div>

        <div class="clearfix">
            <div class="ttd">
                <p>Dikeluarkan di Ambarita</p>
                <p>pada tanggal: {{ $tanggal_surat }}</p>
                <p class="kepala-desa">KEPALA DESA AMBARITA</p>
                <p style="margin-top: 110px;">({{ $nama_kepala_desa }})</p>
            </div>
        </div>
    </div>
</body>

</html>