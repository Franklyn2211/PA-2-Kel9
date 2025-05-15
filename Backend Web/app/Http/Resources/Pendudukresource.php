<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PendudukResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nik' => $this->nik ?? 'NIK tidak tersedia',
            'name' => $this->name ?? 'Nama tidak tersedia',
            'gender' => $this->gender,
            'gender_label' => $this->gender_label,
            'address' => $this->address ?? 'Alamat belum diisi',
            'birth_date' => $this->birth_date?->format('Y-m-d'),
            'age' => $this->age,
            'religion' => $this->religion ?? 'Agama belum diisi',
            'family_card_number' => $this->family_card_number ?? 'Nomor KK belum diisi',
            'created_at' => $this->created_at?->toDateTimeString(),
            'updated_at' => $this->updated_at?->toDateTimeString()
        ];
    }

    /**
     * Get additional data that should be returned with the resource array.
     *
     * @return array<string, mixed>
     */
    public function with(Request $request): array
    {
        return [
            'meta' => [
                'version' => '1.0',
                'author' => 'Your Application',
                'timestamp' => now()->toDateTimeString(),
                'status' => 'success',
                'message' => 'Data penduduk berhasil diambil'
            ],
            'links' => [
                'self' => $request->fullUrl(),
                'list' => route('residents.index')
            ]
        ];
    }
}