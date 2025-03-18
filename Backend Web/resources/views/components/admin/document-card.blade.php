@props([
    'title' => 'Dokumen',
    'user' => 'Pengguna',
    'date' => 'Tanggal',
    'status' => 'pending',
    'statusText' => 'Dalam Proses',
    'icon' => 'fa-file-alt'
])

<div class="document-card {{ $status }}">
    <div class="document-icon bg-{{ $status === 'completed' ? 'success' : 'warning' }}-soft text-{{ $status === 'completed' ? 'success' : 'warning' }}">
        <i class="fas {{ $icon }}"></i>
    </div>
    <div class="document-info">
        <div class="document-title">{{ $title }}</div>
        <div class="document-meta">
            <div><i class="fas fa-user"></i> {{ $user }}</div>
            <div><i class="fas fa-calendar"></i> {{ $date }}</div>
        </div>
    </div>
    <div class="document-status bg-{{ $status === 'completed' ? 'success' : 'warning' }}-soft text-{{ $status === 'completed' ? 'success' : 'warning' }}">
        {{ $statusText }}
    </div>
</div> 