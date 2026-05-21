import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'fullscreen_viewer.dart';

class PhotoGrid extends StatelessWidget {
  static const _total = 30;

  const PhotoGrid({super.key});

  String _url(int seed) => 'https://picsum.photos/seed/$seed/400/400';

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemCount: _total,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullscreenViewer(
                initialIndex: index,
                total: _total,
              ),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: _url(index + 1),
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.white10,
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.white10,
              child: const Icon(
                Icons.broken_image_outlined,
                size: 28,
                color: Colors.white30,
              ),
            ),
          ),
        );
      },
    );
  }
}
