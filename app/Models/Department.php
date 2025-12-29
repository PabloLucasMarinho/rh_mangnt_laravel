<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
  protected $fillable = ['name'];
  // each department can be filled with multiple users
  public function users()
  {
    return $this->belongsToMany(User::class);
  }
}
