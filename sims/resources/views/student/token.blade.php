@extends('layouts.app')

@section('title', 'Tokens')

@section('content')
<div>
    @if ($token)
    <div class="alert alert-success">
        <strong>Social Token:</strong>
        <input type="text" value="{{ $token->value }}" id="socialTokenInput" readonly>
        <button onclick="copyToClipboard()">Copy</button>
    </div>
    @else
    <div class="alert alert-info">
        No social token available.
    </div>
    @endif
</div>

<script>
function copyToClipboard() {
    var copyText = document.getElementById("socialTokenInput");

    copyText.select();
    copyText.setSelectionRange(0, 99999);

    document.execCommand("copy");

    alert("Copied the social token: " + copyText.value);
}
</script>
@endsection