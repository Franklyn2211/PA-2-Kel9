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
        // Generate URL untuk photo dan qris_image
        $photoUrl = $this->photo ? url('storage/' . $this->photo) : null;
        $qrisUrl = $this->qris_image ? url('storage/' . $this->qris_image) : null;

        return array_merge(parent::toArray($request), [
            'photo_url' => $photoUrl,
            'qris_url' => $qrisUrl,
        ]);
    }
}