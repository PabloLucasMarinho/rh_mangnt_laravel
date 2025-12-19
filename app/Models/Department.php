<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
  // each department can be filled with multiple users
  public function users()
  {
    return $this->belongsToMany(User::class);
  }
}
