import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_palette.dart';

class CardThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  const CardThumbnail({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 140,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: p.surface2,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(Icons.image_not_supported, color: p.textDim),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        // Sprites are 96px sources; cap decode size so large grids stay cheap,
        // and upscale nearest-neighbor so pixels stay crisp instead of blurry.
        memCacheWidth: 192,
        filterQuality: FilterQuality.none,
        fadeInDuration: const Duration(milliseconds: 120),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: p.surface2,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: p.surface2,
          child: const Icon(Icons.error, color: AppColors.red),
        ),
      ),
    );
  }
}
