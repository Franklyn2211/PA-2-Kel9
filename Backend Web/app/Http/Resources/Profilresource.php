<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ProfilResource extends JsonResource
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
            'history' => $this->history,
            'visi' => $this->visi,
            'misi' => $this->misi,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
