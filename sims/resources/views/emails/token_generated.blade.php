<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Token Generated</title>
    <style>
        .token-container {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            font-size: 16px;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <div>
        <h2>Token Generated</h2>
        <p>{{ $message }}</p>
        <p>Here is your token:</p>
        <div class="token-container">
            {{ $token }}
        </div>
        <button onclick="copyToClipboard('{{ $token }}')">Copy Token</button>
    </div>

    <script>
        function copyToClipboard(text) {
            const el = document.createElement('textarea');
            el.value = text;
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
            alert('Token copied to clipboard!');
        }
    </script>
</body>
</html>
