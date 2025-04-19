<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        // Base structure yang sama untuk semua tipe
        $response = [
            'id' => $this->id,
            'created_at' => $this->created_at?->toDateTimeString(),
            'updated_at' => $this->updated_at?->toDateTimeString(),
            'photo_url' => $this->photo ? url('storage/' . ltrim($this->photo, '/')) : null,
        ];

        // Deteksi tipe data (berita atau produk)
        if (isset($this->product_name)) {
            // Response untuk produk/UMKM
            $response = array_merge($response, [
                'product_name' => $this->product_name ?? '',
                'description' => $this->description ?? '',
                'photo' => $this->photo,
                'location' => $this->location ?? '',
                'price' => $this->price ?? '0',
                'stock' => $this->stock ?? 0,
                'phone' => $this->phone ?? '',
                'umkm_id' => $this->umkm_id ?? 0,
                'qris_url' => $this->qris_url ?? $this->umkm->qris_url ?? null,
                'umkm' => $this->whenLoaded('umkm', function() {
                    return [
                        'id' => $this->umkm->id ?? 0,
                        'nama_umkm' => $this->umkm->nama_umkm ?? '',
                        'qris_url' => $this->umkm->qris_url ?? null
                    ];
                })
            ]);
        } else {
            // Response untuk berita
            $response = array_merge($response, [
                'title' => $this->title ?? '',
                'description' => $this->description ?? '',
                'photo' => $this->photo,
                'qris_url' => null // Selalu null untuk berita
            ]);
        }

        return $response;
    }
}