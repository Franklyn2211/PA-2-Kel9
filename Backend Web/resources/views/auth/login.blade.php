<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
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
            /* Background akan ditambahkan oleh Anda */
            background: url('assets/img/ambarita.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.1); /* Transparansi putih */
            backdrop-filter: blur(10px); /* Efek blur untuk kesan modern */
            border-radius: 15px;
            padding: 2rem;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* Bayangan lembut */
            border: 1px solid rgba(255, 255, 255, 0.3); /* Garis tepi transparan */
        }
        .login-container h2 {
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
        .btn-login {
            background: linear-gradient(45deg, #00ff55, #00ff558e);
            border: none;
            border-radius: 25px;
            padding: 0.75rem;
            width: 100%;
            color: #fff;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            background: linear-gradient(45deg, #00b32d, #1cba00);
            transform: translateY(-2px);
        }
        .form-check-label {
            color: #fff;
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
    <div class="login-container">
        <h2>Admin Desa</h2>

        <!-- Pesan Error -->
        @if ($errors->any())
            <div class="alert alert-danger">
                {{ $errors->first() }}
            </div>
        @endif

        <!-- Form Login -->
        <form action="{{ route('login') }}" method="POST">
            @csrf
            <div class="input-group mb-3">
                <input type="email" name="email" class="form-control" placeholder="Email" value="{{ old('email') }}" required>
                <div class="input-group-append">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                </div>
            </div>
            <div class="input-group mb-3">
                <input type="password" name="password" class="form-control" placeholder="Password" required>
                <div class="input-group-append">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                </div>
            </div>
            <div class="form-check mb-3">
                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                <label class="form-check-label" for="remember">Ingat Saya</label>
            </div>
            <button type="submit" class="btn btn-login">Masuk</button>
        </form>

        <!-- Link Tambahan -->
        <div class="text-center mt-3">
            <a href="#">Lupa kata sandi?</a>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
