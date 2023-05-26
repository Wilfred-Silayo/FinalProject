
// get the password input element
var passwordField = document.getElementById('password');

// get the eye button element
var togglePasswordButton = document.getElementById('togglePassword');

// add a click event listener to the button
togglePasswordButton.addEventListener('click', function() {
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
    } else {
        passwordField.type = 'password';
    }
});
