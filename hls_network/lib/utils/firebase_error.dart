import 'package:firebase_auth/firebase_auth.dart';

String handleFirebaseError(dynamic error) {
  String errorMessage = 'An error occurred. Please try again later.';

  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        errorMessage = 'Invalid email address.';
        break;
      case 'user-not-found':
        errorMessage = 'User not found.';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email address is already in use.';
        break;
      case 'weak-password':
        errorMessage = 'Password should be atleast 6 characters.';
        break;
      case 'network-request-failed':
        errorMessage =
            'Network request failed. Please check your internet connection.';
        break;
      default:
        errorMessage = 'Something went wrong.';
        break;
    }
  } else if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        errorMessage = 'Permission denied.';
        break;
      case 'unavailable':
        errorMessage = 'The service is currently unavailable.';
        break;
      case 'network-request-failed':
        errorMessage =
            'Network request failed. Please check your internet connection.';
        break;
      default:
        errorMessage = 'An error occurred.';
        break;
    }
  }

  return errorMessage;
}
