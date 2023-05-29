<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SocialToken extends Model
{
    protected $primaryKey='id';
    protected $fillable = [
        'id',
        'user_id',
        'value',
        'expires_at',
    ]; 
}
