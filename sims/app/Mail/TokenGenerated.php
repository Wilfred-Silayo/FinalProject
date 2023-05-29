<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class TokenGenerated extends Mailable
{
    use Queueable, SerializesModels;

    public $token;
    public $message;

    /**
     * Create a new message instance.
     *
     * @param  string  $token
     * @param  string  $message
     */
    public function __construct($token, $message)
    {
        $this->token = $token;
        $this->message = $message;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->subject('Token Generated')
                    ->view('emails.token_generated')
                    ->with([
                        'emailMessage' => $this->message,
                        'token'=>$this->token,
                    ]);
     
    }
}

