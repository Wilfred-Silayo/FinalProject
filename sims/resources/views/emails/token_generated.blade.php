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
        <p>{{ $emailMessage }}</p>
        <p>Here is your token:</p>
        <div class="token-container">
            {{ $token }}
        </div>
        <p>
            <strong>This token will expire after 15 minutes</strong> 
        </p>
        <p>
            To copy the token, tap and hold on the token, then choose the copy option from the menu.
            If the copy option is not available, you can manually select and copy the token.
        </p>
    </div>
</body>
</html>
