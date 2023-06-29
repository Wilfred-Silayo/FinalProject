import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class ShowImage extends StatefulWidget {
  static Route<dynamic> route(String imageUrl) {
    return MaterialPageRoute(
      builder: (context) => ShowImage(imageUrl: imageUrl),
    );
  }

  final String imageUrl;

  const ShowImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}
