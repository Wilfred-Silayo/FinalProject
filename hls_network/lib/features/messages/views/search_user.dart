import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/messages/widgets/search_tile.dart';
import 'package:hls_network/features/search/controller/search_controller.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class SearchUser extends ConsumerStatefulWidget {
  static route() {
    return MaterialPageRoute(
      builder: (context) => const SearchUser(),
    );
  }

  const SearchUser({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchUserState();
}

class _SearchUserState extends ConsumerState<SearchUser> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: currentTheme.brightness == Brightness.dark
                  ? Pallete.searchBarColor
                  : Pallete.whiteColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search user to chat with',
            ),
          ),
        ),
      ),
      body: currentUser == null
          ? const Loader()
          : isShowUsers
              ? ref.watch(searchUserProvider(searchController.text)).when(
                    data: (users) {
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = users[index];
                          if (user.uid != currentUser.uid) {
                            return SearchTile(userModel: user);
                          }
                          return const SizedBox();
                        },
                      );
                    },
                    error: (error, st) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  )
              : const SizedBox(),
    );
  }
}
