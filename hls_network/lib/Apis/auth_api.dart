import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hls_network/providers/firebase_providers.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';

final authAPIProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthAPI(auth: auth);
});


class AuthAPI {
  final FirebaseAuth _auth;

  AuthAPI({required FirebaseAuth auth}) : _auth = auth;


  Future<User?> currentUserAccount() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  FutureEither<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }


  FutureEither<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(credential);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }


  FutureEitherVoid logout() async {
    try {
      await _auth.signOut();
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
