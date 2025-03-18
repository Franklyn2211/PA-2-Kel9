@props([
    'day' => '01',
    'month' => 'Jan',
    'title' => 'Acara',
    'time' => '00:00 - 00:00',
    'location' => 'Lokasi'
])

<div class="event-card">
    <div class="event-date">
        <div class="event-day">{{ $day }}</div>
        <div class="event-month">{{ $month }}</div>
    </div>
    <div class="event-content">
        <div class="event-title">{{ $title }}</div>
        <div class="event-details">
            <div class="event-detail">
                <i class="fas fa-clock"></i> {{ $time }}
            </div>
            <div class="event-detail">
                <i class="fas fa-map-marker-alt"></i> {{ $location }}
            </div>
        </div>
    </div>
</div> 