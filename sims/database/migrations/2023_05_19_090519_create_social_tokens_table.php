<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('social_tokens', function (Blueprint $table) {
            $table->id();
            $table->string('user_id');
            $table->integer('value');
            $table->dateTime('expires_at');
            $table->foreign('user_id')->references('username')
            ->on('users')->onDelete('cascade')->onUpdate('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('social_tokens');
    }
};
