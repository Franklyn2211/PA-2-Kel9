@props([
    'title' => 'Selamat Datang',
    'subtitle' => 'Subtitle',
    'buttons' => []
])

<div class="welcome-card animate-on-scroll fadeIn">
    <div class="welcome-content">
        <div class="welcome-title">{{ $title }}</div>
        <div class="welcome-subtitle">{{ $subtitle }}</div>
        <div class="welcome-actions">
            {{ $slot }}
        </div>
    </div>
</div> 