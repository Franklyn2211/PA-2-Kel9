<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class GaleriResource extends JsonResource
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
            'title' => $this->title,
            'photo' => $this->photo,
            'photo_url' => $this->photo ? url('storage/' . ltrim($this->photo, '/')) : null,
            'date_taken' => $this->date_taken,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
