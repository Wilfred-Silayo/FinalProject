import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/home/widgets/custom_circularAvator.dart';
import 'package:hls_network/features/posts/controller/post_controller.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/RoundedSmallButton.dart';
import 'package:hls_network/utils/loading_page.dart';
import 'package:hls_network/utils/utils.dart';

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({super.key});

  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  List<File> images = [];
  String? photoUrl;
  final TextEditingController postTextController = TextEditingController();

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: postTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  void clearImage() {
    setState(() {
      images = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            clearImage();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: RoundedSmallButton(
              onTap: () => sharePost(),
              label: 'Post',
              backgroundColor: currentTheme.brightness == Brightness.dark
                  ? Pallete.tealColor
                  : Pallete.whiteColor,
              textColor: currentTheme.brightness == Brightness.light
                  ? Pallete.tealColor
                  : Pallete.whiteColor,
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(height: 10),
                            CustomCircularAvator(
                              photoUrl: photoUrl,
                              radius: 30,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                controller: postTextController,
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Type here...",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                        if (images.isNotEmpty)
                          CarouselSlider(
                            items: images.map(
                              (file) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Image.file(file),
                                );
                              },
                            ).toList(),
                            options: CarouselOptions(
                              height: 400,
                              enableInfiniteScroll: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset('assets/gallery.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
