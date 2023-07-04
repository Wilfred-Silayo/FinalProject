import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/posts/views/show_image.dart';
import 'package:hls_network/providers/theme_provider.dart';

class CarouselImage extends ConsumerStatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({
    super.key,
    required this.imageLinks,
  });

  @override
  ConsumerState<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends ConsumerState<CarouselImage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map(
                (link) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        ShowImage.route(link),
                      );
                    },
                    child: Image.network(
                      link,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                height: 400,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  width: 12,
                  height: 12,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentTheme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(
                            _current == e.key ? 0.9 : 0.4,
                          )
                        : Colors.black.withOpacity(
                            _current == e.key ? 0.9 : 0.4,
                          ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
