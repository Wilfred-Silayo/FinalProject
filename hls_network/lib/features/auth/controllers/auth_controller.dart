import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/auth_api.dart';
import 'package:hls_network/Apis/user_api.dart';
import 'package:hls_network/features/auth/views/login.dart';
import 'package:hls_network/features/home/views/home_screen.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/utils.dart';
import 'package:random_string/random_string.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = StreamProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.uid;
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(currentUserId);
});

final userDetailsProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Stream<User?> get authStateChange => _authAPI.authStateChange;

  void signUp({
    required String email,
    required String password,
    required String fullName,
    required String uniId,
    required String verifiedAs,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        String username = await generateUniqueUsername();
        UserModel userModel = UserModel(
          email: email,
          username: username,
          fullName: fullName,
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.user!.uid,
          bio: '',
          university: uniId,
          verifiedAs: verifiedAs,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created successfuly!');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _userAPI.getUserData(uid);
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    });
  }

  void deleteAccount(BuildContext context) async {
    final res = await _authAPI.deleteAccount();
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Account Deleted successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    });
  }

  void changePassword(
    BuildContext context, String password
  ) async {
    final res = await _authAPI.changePassword(password);
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Password changed successfully');
    });
  }

  void verifyEmail(
    BuildContext context,
  ) async {
    final res = await _authAPI.sendEmailVerification();
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Verification email sent successfully. Please check your inbox');
    });
  }

    void changeEmail(
    BuildContext context, String newEmail
  ) async {
    final res = await _authAPI.changeEmail(newEmail);
    res.fold((l) => null, (r) {
      showSnackBar(context, 'Email changed successfully');
    });
  }

  Future<String> generateUniqueUsername() async {
    String username = '';
    bool isUnique = false;

    while (!isUnique) {
      String randomString = randomAlpha(8);

      username = 'user_$randomString';

      bool value =
          await _userAPI.checkUsernameAvailabilityStream(username).first;
      if (value == true) {
        isUnique = true;
      }
    }

    return username;
  }
}
