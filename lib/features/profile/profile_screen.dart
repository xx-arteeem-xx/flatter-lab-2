import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../models/info_item.dart';
import 'widgets/avatar_section.dart';
import 'widgets/info_card.dart';
import 'widgets/interest_chips.dart';
import 'widgets/like_button.dart';
import 'widgets/resume_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _likes = 0;
  bool _liked = false;
  late SharedPreferences _prefs;

  static const _likesKey = 'profile_likes';
  static const _likedKey = 'profile_liked';

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _likes = _prefs.getInt(_likesKey) ?? 0;
        _liked = _prefs.getBool(_likedKey) ?? false;
      });
    }
  }

  int get _age {
    final birth = DateTime(2004, 10, 6);
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) age--;
    return age;
  }

  void _onLike() {
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes - 1).clamp(0, 9999);
    });
    _prefs.setInt(_likesKey, _likes);
    _prefs.setBool(_likedKey, _liked);
  }

  void _onMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.messageSent),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<InfoItem> get _infoItems => [
        InfoItem(
          icon: Icons.school_outlined,
          label: 'Университет',
          value: '${AppStrings.university} · ${AppStrings.grade}',
        ),
        InfoItem(
          icon: Icons.business_center_outlined,
          label: 'Направление',
          value: AppStrings.faculty,
        ),
        InfoItem(
          icon: Icons.work_outline_rounded,
          label: 'Место работы',
          value: '${AppStrings.workplace}, ${AppStrings.employer}',
        ),
        InfoItem(
          icon: Icons.people_outline_rounded,
          label: 'ВКонтакте',
          value: 'vk.com/xx_arteem_xx',
          url: AppStrings.vkUrl,
        ),
        InfoItem(
          icon: Icons.send_rounded,
          label: 'Telegram',
          value: AppStrings.tgHandle,
          url: AppStrings.tgUrl,
        ),
        InfoItem(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: AppStrings.githubHandle,
          url: AppStrings.githubUrl,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Avatar ─────────────────────────────────────────────────
                AvatarSection(age: _age),
                const SizedBox(height: 32),

                // ── Info cards ─────────────────────────────────────────────
                _SectionLabel(text: 'Информация'),
                const SizedBox(height: 12),
                ..._infoItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InfoCard(item: item),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Interests ──────────────────────────────────────────────
                _SectionLabel(text: 'Интересы'),
                const SizedBox(height: 12),
                const InterestChips(),
                const SizedBox(height: 32),

                // ── Actions ────────────────────────────────────────────────
                const ResumeButton(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LikeButton(
                        count: _likes,
                        liked: _liked,
                        onTap: _onLike,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _onMessage,
                        icon: const Icon(Icons.message_outlined, size: 18),
                        label: const Text('Написать'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withOpacity(0.25)),
          ),
          child: Text(
            text.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: accent,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
