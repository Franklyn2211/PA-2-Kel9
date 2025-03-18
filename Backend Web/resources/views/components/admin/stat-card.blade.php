@props([
    'icon' => 'fa-chart-line',
    'value' => '0',
    'label' => 'Statistik',
    'trend' => null,
    'trendValue' => null,
    'trendIcon' => null,
    'trendClass' => 'stat-trend-up'
])

<div class="card h-100">
    <div class="card-body p-0">
        <div class="stat-card">
            <div class="stat-content p-4">
                <div class="stat-icon">
                    <i class="fas {{ $icon }}"></i>
                </div>
                <div class="stat-value">{{ $value }}</div>
                <div class="stat-label mb-2">{{ $label }}</div>
                @if($trend)
                <div class="stat-trend {{ $trendClass }}">
                    <i class="fas {{ $trendIcon ?? 'fa-arrow-up' }} me-1"></i> {{ $trend }}
                </div>
                @endif
            </div>
        </div>
    </div>
</div> 