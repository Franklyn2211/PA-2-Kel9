<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class StaffResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'position' => $this->position,
            'photo' => $this->photo,
            'phone' => $this->phone,
            'photo_url' => $this->photo ? url('storage/' . ltrim($this->photo, '/')) : null,
            'email' => $this->email,
            'npsn_active' => $this->npsn_active,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
