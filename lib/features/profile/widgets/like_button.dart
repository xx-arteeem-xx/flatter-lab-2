import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LikeButton extends StatelessWidget {
  final int count;
  final bool liked;
  final VoidCallback onTap;

  const LikeButton({
    super.key,
    required this.count,
    required this.onTap,
    this.liked = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: AppColors.like,
        size: 18,
      ),
      label: Text('$count'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.like,
        side: BorderSide(color: AppColors.like.withOpacity(0.6), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      ),
    );
  }
}
