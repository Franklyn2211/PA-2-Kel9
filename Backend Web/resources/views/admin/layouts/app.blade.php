<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Desa')</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('assets/images/logo.png') }}" />
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- Summernote CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.css" />

    <!-- Admin CSS -->
    <link rel="stylesheet" href="{{ asset('css/admin/variables.css') }}">
    <link rel="stylesheet" href="{{ asset('css/admin/animations.css') }}">
    <link rel="stylesheet" href="{{ asset('css/admin/layout.css') }}">
    <link rel="stylesheet" href="{{ asset('css/admin/sidebar.css') }}">
    <link rel="stylesheet" href="{{ asset('css/admin/header.css') }}">
    <link rel="stylesheet" href="{{ asset('css/admin/dashboard.css') }}">

    <!-- Custom Styles -->
    @yield('styles')
</head>
<body>
    <div class="layout-wrapper" id="app">
        <!-- Sidebar -->
        @include('admin.layouts.sidebar')

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            @include('admin.layouts.header')

            <!-- Page Content -->
            <div class="page-content">
                @yield('content')
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/assets/plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 5 Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- ApexCharts -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <!-- Summernote JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.js"></script>

    <!-- Custom Scripts -->
    <script>
        $(document).ready(function() {
            $('#summernote').summernote({
                height: 200,
                placeholder: 'Tulis deskripsi di sini...',
                tabsize: 2,
            });
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Apply animations to dropdown menu items with staggered delay
            function setupDropdownAnimations() {
                const dropdowns = document.querySelectorAll('.dropdown-menu');

                dropdowns.forEach(dropdown => {
                    const items = dropdown.querySelectorAll('.dropdown-item');

                    // Reset any existing animations
                    items.forEach(item => {
                        item.style.opacity = '0';
                        item.style.transform = 'translateX(-20px)'; // Increased movement for more visible effect
                        item.style.transition = 'all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)'; // Bouncy effect
                    });

                    // Set up the observers for each dropdown
                    const observer = new MutationObserver(mutations => {
                        mutations.forEach(mutation => {
                            if (mutation.attributeName === 'class' &&
                                dropdown.classList.contains('show')) {
                                // Animate items with staggered delay
                                items.forEach((item, index) => {
                                    setTimeout(() => {
                                        item.style.opacity = '1';
                                        item.style.transform = 'translateX(0)';
                                    }, 70 * (index + 1)); // Slightly longer delay between items
                                });
                            }
                        });
                    });

                    // Start observing
                    observer.observe(dropdown, {
                        attributes: true
                    });
                });
            }

            // Initialize dropdown animations
            setupDropdownAnimations();

            // Toggle sidebar
            const menuToggle = document.getElementById('menu-toggle');
            const layoutWrapper = document.getElementById('app');

            menuToggle.addEventListener('click', function() {
                layoutWrapper.classList.toggle('sidebar-collapsed');

                // Update the toggle icon based on sidebar state
                const isCollapsed = layoutWrapper.classList.contains('sidebar-collapsed');
                menuToggle.innerHTML = isCollapsed ?
                    '<i class="fas fa-expand-alt"></i>' :
                    '<i class="fas fa-bars"></i>';
            });

            // Initialize bootstrap tooltips
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            const tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });

            // Add enhanced animations for elements when scrolled into view
            const animateElements = document.querySelectorAll('.animate-on-scroll');

            const observer = new IntersectionObserver((entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        // More subtle animations with shorter durations
                        if (entry.target.classList.contains('fadeIn')) {
                            entry.target.style.animation = 'fadeIn 0.5s ease forwards';
                        } else if (entry.target.classList.contains('slideInLeft')) {
                            entry.target.style.animation = 'slideInLeft 0.5s ease forwards';
                        } else if (entry.target.classList.contains('slideInRight')) {
                            entry.target.style.animation = 'slideInRight 0.5s ease forwards';
                        } else if (entry.target.classList.contains('slideInUp')) {
                            entry.target.style.animation = 'slideInUp 0.5s ease forwards';
                        } else {
                            // Default animation if no class specified
                            entry.target.style.animation = 'fadeIn 0.5s ease forwards';
                        }

                        // Add transition after animation completes
                        entry.target.style.transition = 'all 0.3s ease';

                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: 0.1, // Standard threshold is fine
                rootMargin: '0px 0px -10px 0px' // Less aggressive trigger
            });

            animateElements.forEach(element => {
                // Set initial state to invisible
                element.style.opacity = 0;
                observer.observe(element);
            });
        });
    </script>

    @yield('scripts')
</body>
</html>
