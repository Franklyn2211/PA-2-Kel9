<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi UMKM</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('assets/images/logo.png') }}" />
    <!-- Bootstrap CSS via CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <!-- Font Awesome untuk ikon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            background: url('{{ asset("assets/img/ambarita.jpg") }}') no-repeat center center fixed;
            background-size: cover;
        }
        .register-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .register-container h2 {
            color: #fff;
            text-align: center;
            margin-bottom: 1.5rem;
            font-weight: 300;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .form-control {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: #fff;
            border-radius: 25px;
            padding: 0.75rem 1rem;
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }
        .input-group-text {
            background: transparent;
            border: none;
            color: #fff;
        }
        .btn-register {
            background: linear-gradient(45deg, #00ff55, #00ff558e);
            border: none;
            border-radius: 25px;
            padding: 0.75rem;
            width: 100%;
            color: #fff;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-register:hover {
            background: linear-gradient(45deg, #00b32d, #1cba00);
            transform: translateY(-2px);
        }
        .alert {
            background: rgba(255, 0, 0, 0.2);
            border: none;
            color: #fff;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        a {
            color: #008000;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Daftar UMKM</h2>

        <!-- Pesan Error -->
        @if ($errors->any())
            <div class="alert alert-danger">
                {{ $errors->first() }}
            </div>
        @endif

        <!-- Form Registrasi -->
<form action="{{ route('register.umkm.post') }}" method="POST">
    @csrf

    <div class="input-group mb-3">
        <input type="text" name="nama_umkm" class="form-control" placeholder="Nama UMKM" value="{{ old('nama_umkm') }}" required>
        <div class="input-group-append">
            <span class="input-group-text"><i class="fas fa-store"></i></span>
        </div>
    </div>

    <div class="input-group mb-3">
        <input type="email" name="email" class="form-control" placeholder="Email" value="{{ old('email') }}" required>
        <div class="input-group-append">
            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
        </div>
    </div>

    <div class="input-group mb-3">
        <span class="input-group-text">+62</span>
        <input type="text" name="phone" class="form-control" placeholder="Nomor HP" value="{{ old('phone') }}" maxlength="11" required>
        <div class="input-group-append">
            <span class="input-group-text"><i class="fas fa-phone"></i></span>
        </div>
    </div>

    <div class="input-group mb-3">
        <input type="password" name="password" class="form-control" placeholder="Password" required>
        <div class="input-group-append">
            <span class="input-group-text"><i class="fas fa-lock"></i></span>
        </div>
    </div>

    <div class="input-group mb-3">
        <input type="password" name="password_confirmation" class="form-control" placeholder="Konfirmasi Password" required>
        <div class="input-group-append">
            <span class="input-group-text"><i class="fas fa-lock"></i></span>
        </div>
    </div>

    <button type="submit" class="btn btn-register">Daftar</button>
</form>


        <!-- Link Tambahan -->
        <div class="text-center mt-3">
            <a href="{{ route('login.umkm') }}">Sudah punya akun? Masuk di sini</a> |
            <a href="{{ route('login') }}">Login Admin</a>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
