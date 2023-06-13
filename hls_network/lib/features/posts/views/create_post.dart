// import 'dart:io';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hls_network/themes/themes_helper.dart';
// import '../../../controller/firestore_methods.dart';
// import '../../../providers/theme_provider.dart';
// import '../../../utils/utils.dart';
// import '../../../utils/RoundedSmallButton.dart';
// import '../../home/widgets/custom_circularAvator.dart';

// class CreatePost extends ConsumerStatefulWidget {
//   const CreatePost({super.key});

//   @override
//   ConsumerState<CreatePost> createState() => _CreatePostState();
// }

// class _CreatePostState extends ConsumerState<CreatePost> {
//   List<File> images = [];
//   bool isLoading = false;
//   String? photoUrl;
//   String? currentUserId;
//   final TextEditingController _descriptionController = TextEditingController();

//   void onPickImages() async {
//     images = await pickImages();
//     setState(() {});
//   }

//   Future<void> fetchUserInfo() async {
//     final user = FirebaseAuth.instance.currentUser;
//     final userId = user?.uid;

//     if (userId != null) {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       final userData = userDoc.data() as Map<String, dynamic>;

//       setState(() {
//         photoUrl = userData['photoUrl'] ?? '';
//         currentUserId = userData['uid'] ?? '';
//       });
//     }
//   }

// void postImage(context, String uid) async {
//   setState(() {
//     isLoading = true;
//   });
  
//   String description = _descriptionController.text;
//   List<File> images = this.images;
  
//   if (description.isEmpty && images.isEmpty) {
//     setState(() {
//       isLoading = false;
//     });
    
//     showSnackBar(
//       context,
//       'Please enter a description or select at least one image.',
//     );
    
//     return; 
//   }
  
//   try {
//     String res = await FireStoreMethods().uploadPost(
//       description,
//       images,
//       uid,
//     );
    
//     if (res == "success") {
//       setState(() {
//         isLoading = false;
//       });
      
//       showSnackBar(
//         context,
//         'Posted!',
//       );
//       clearImage();
//       Navigator.pop(context);
//     } else {
//       showSnackBar(context, res);
//     }
//   } catch (err) {
//     setState(() {
//       isLoading = false;
//     });
    
//     showSnackBar(
//       context,
//       err.toString(),
//     );
//   }
// }

//   void clearImage() {
//     setState(() {
//       images = [];
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchUserInfo();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentTheme = ref.watch(themeNotifierProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Post'),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             clearImage();
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.close, size: 30),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: RoundedSmallButton(
//               onTap: () => postImage(context, currentUserId!),
//               label: 'Post',
//               backgroundColor: currentTheme.brightness == Brightness.dark
//                   ? Pallete.tealColor
//                   : Pallete.whiteColor,
//               textColor: currentTheme.brightness == Brightness.light
//                   ? Pallete.tealColor
//                   : Pallete.whiteColor,
//             ),
//           )
//         ],
//       ),
//       body: Stack(
//         children: [Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       const SizedBox(height: 10),
//                       CustomCircularAvator(
//                         photoUrl: photoUrl,
//                         radius: 30,
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: TextField(
//                           controller: _descriptionController,
//                           style: const TextStyle(
//                             fontSize: 22,
//                           ),
//                           decoration: const InputDecoration(
//                             hintText: "Type here...",
//                             hintStyle: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                           maxLines: null,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (images.isNotEmpty)
//                     CarouselSlider(
//                       items: images.map(
//                         (file) {
//                           return Container(
//                             width: MediaQuery.of(context).size.width,
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 5,
//                             ),
//                             child: Image.file(file),
//                           );
//                         },
//                       ).toList(),
//                       options: CarouselOptions(
//                         height: 400,
//                         enableInfiniteScroll: false,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ), if (isLoading)
//       Positioned.fill(
//         child: Container(
//           color: Colors.black54,
//           child: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
        
//         ]
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.only(bottom: 10),
//         decoration: const BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: Pallete.greyColor,
//               width: 0.3,
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0).copyWith(
//                 left: 15,
//                 right: 15,
//               ),
//               child: GestureDetector(
//                 onTap: onPickImages,
//                 child: SvgPicture.asset('assets/gallery.svg'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
