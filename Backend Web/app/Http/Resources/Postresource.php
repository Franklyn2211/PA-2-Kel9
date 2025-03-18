<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class Postresource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $photoUrl = $this->photo
            ? url('storage/' . $this->photo)
            : null;

        return array_merge($this->resource->toArray(), [
            'photo_url' => $photoUrl,
        ]);
    }
}
