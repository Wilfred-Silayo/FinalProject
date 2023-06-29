import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/features/profile/controller/user_profile_controller.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/rounded_small_button.dart';
import 'package:hls_network/utils/loading_page.dart';
import 'package:hls_network/utils/utils.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController usernameController;
  late TextEditingController bioController;
  late TextEditingController fullNameController;
  File? bannerFile;
  File? profileFile;
  bool? isUsernameAvailable = true;
  bool? isInvalidUsername = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.username ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.bio ?? '',
    );
    fullNameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.fullName ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    bioController.dispose();
    fullNameController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  void checkUsernameAvailability(String value) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_]*$');
    if (value.isNotEmpty) {
      if (!regex.hasMatch(value) || value.contains(' ')) {
        setState(() {
          isInvalidUsername = true;
          return;
        });
      }
      bool? availability = ref.read(usernameAvailabilityProvider(value)).value;
      String currentUsername =
          ref.read(currentUserDetailsProvider).value!.username;
      if (currentUsername == value) {
        setState(() {
          isUsernameAvailable = true;
        });
      } else {
        setState(() {
          isUsernameAvailable = availability;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          RoundedSmallButton(
            onTap: () {
              final username = usernameController.text;
              final fullName = fullNameController.text;

              if (username.isNotEmpty &&
                  fullName.isNotEmpty &&
                  isUsernameAvailable == true &&
                  isInvalidUsername == false) {
                return ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                      userModel: user!.copyWith(
                        bio: bioController.text,
                        username: usernameController.text,
                        fullName: fullNameController.text,
                      ),
                      context: context,
                      bannerFile: bannerFile,
                      profileFile: profileFile,
                    );
              } else {
                return showSnackBar(
                    context, 'Username and Your Name cannot be empty.');
              }
            },
            label: 'save',
            backgroundColor: Pallete.tealColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(
                                  bannerFile!,
                                  fit: BoxFit.fitWidth,
                                )
                              : user.bannerPic.isEmpty
                                  ? Container(
                                      color: Pallete.tealColor,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: user.bannerPic,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                        color: Pallete.whiteColor,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: GestureDetector(
                            onTap: selectBannerImage,
                            child: const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Stack(
                            children: [
                              profileFile != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 40,
                                    )
                                  : CustomCircularAvator(
                                      photoUrl: user.profilePic, radius: 45),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 30,
                                    color: Pallete.tealColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: fullNameController,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      hintText: 'Your name',
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    onChanged: (value) => checkUsernameAvailability(value),
                    maxLength: 13,
                    decoration: InputDecoration(
                      hintText: 'username',
                      contentPadding: const EdgeInsets.all(18),
                      errorText: isInvalidUsername == true
                          ? 'Invalid username. Only alphanumeric and underscore characters are allowed.'
                          : isUsernameAvailable != null &&
                                  isUsernameAvailable == false
                              ? 'Username is not available'
                              : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      hintText: 'Bio',
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
    );
  }
}
