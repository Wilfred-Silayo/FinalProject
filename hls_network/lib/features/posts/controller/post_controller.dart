import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/post_api.dart';
import 'package:hls_network/Apis/storage_api.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/notifications/controller/notification_controller.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/utils/enums/post_type.dart';
import 'package:hls_network/utils/utils.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController:
          ref.watch(notificationControllerProvider.notifier),
    );
  },
);

final getPostsProvider = StreamProvider.family((ref, UserModel currentUser) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts(currentUser);
});

final getRepliesToPostsProvider = StreamProvider.family((ref, Post post) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getRepliesToPost(post);
});

final getPostByIdProvider = StreamProvider.family((ref, String id) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

final getPostsByHashtagProvider = StreamProvider.family((ref, String hashtag) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostsByHashtag(hashtag);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Stream<List<Post>> getPosts(UserModel currentUser) {
    return _postAPI.getPosts(currentUser);
  }

  Stream<Post> getPostById(String id) {
   return  _postAPI.getPostById(id);
    
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;

    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes);
    final res = await _postAPI.likePost(post);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: '${user.fullName} liked your post!',
        postId: post.id,
        notificationType: NotificationType.like,
        uid: post.uid,
      );
    });
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextPost(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  Stream<List<Post>> getRepliesToPost(Post post) {
    return _postAPI.getRepliesToPost(post);
  }

  Stream<List<Post>> getPostsByHashtag(String hashtag) {
    return _postAPI.getPostsByHashtag(hashtag);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postAPI.deletePost(post);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post Deleted successfully!'));
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage('posts', images);
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      postType: PostType.image,
      postedAt: DateTime.now(),
      likes: const [],
      id: postId,
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.fullName} replied to your post!',
          postId: postId,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  void _shareTextPost({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      id: postId,
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.fullName} replied to your post!',
          postId: postId,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
