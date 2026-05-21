import 'package:flutter/material.dart';

const _interests = <(String, IconData)>[
  ('Flutter', Icons.flutter_dash),
  ('Dart', Icons.code_rounded),
  ('Android', Icons.android_rounded),
  ('AI / ML', Icons.psychology_outlined),
  ('Git', Icons.merge_type_rounded),
  ('Kotlin', Icons.auto_awesome_rounded),
  ('UX Design', Icons.palette_outlined),
  ('Шахматы', Icons.sports_esports_outlined),
  ('Музыка', Icons.music_note_outlined),
];

class InterestChips extends StatelessWidget {
  const InterestChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _interests
          .map(
            (e) => Chip(
              avatar: Icon(e.$2, size: 14),
              label: Text(e.$1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
          .toList(),
    );
  }
}
