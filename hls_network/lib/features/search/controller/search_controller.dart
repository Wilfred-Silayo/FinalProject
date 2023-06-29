import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/user_api.dart';
import 'package:hls_network/models/user_model.dart';


final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(
    userAPI: ref.watch(userAPIProvider),
  );
});


final searchUserProvider = StreamProvider.family((ref, String query) {
   final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(query);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);


  Stream<List<UserModel>> searchUser(String query) {
    return _userAPI.searchUserByName(query);
  }
}
