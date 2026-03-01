import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveLayout.pagePadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) =>
              const LinearGradient(colors: AppColors.heroGradient)
                  .createShader(b),
          child: const Text('About',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutHeader(isDesktop: isDesktop, isDark: isDark),
                  const SizedBox(height: 80),
                  _ExperienceSection(isDark: isDark),
                  const SizedBox(height: 60),
                  _EducationSection(isDark: isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _AboutHeader extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;
  const _AboutHeader({required this.isDesktop, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final avatar = FadeInRight(
      duration: const Duration(milliseconds: 700),
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 48,
              spreadRadius: 4,
            )
          ],
        ),
        child: const Center(
          child: Text('AM',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.w900)),
        ),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(child: _chip('About Me')),
        const SizedBox(height: 16),
        FadeInDown(
          delay: const Duration(milliseconds: 100),
          child: Text('I\'m ${AppConstants.appName}', style: tt.displaySmall),
        ),
        const SizedBox(height: 8),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: ShaderMask(
            shaderCallback: (b) =>
                const LinearGradient(colors: AppColors.heroGradient)
                    .createShader(b),
            child: Text(AppConstants.appTitle,
                style: tt.headlineSmall!.copyWith(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 20),
        FadeInDown(
          delay: const Duration(milliseconds: 300),
          child: Text(AppConstants.bio, style: tt.bodyLarge),
        ),
        const SizedBox(height: 24),
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: Wrap(spacing: 16, runSpacing: 12, children: [
            _InfoTile(
                icon: Icons.location_on_outlined, label: AppConstants.location),
            _InfoTile(icon: Icons.email_outlined, label: AppConstants.email),
            _InfoTile(icon: Icons.phone_outlined, label: AppConstants.phone),
          ]),
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: info),
          const SizedBox(width: 60),
          avatar,
        ],
      );
    }
    return Column(children: [avatar, const SizedBox(height: 32), info]);
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.heroGradient),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textMutedLight,
              fontSize: 14,
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ExperienceSection extends StatelessWidget {
  final bool isDark;
  const _ExperienceSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(context, 'Work Experience'),
        const SizedBox(height: 28),
        ...AppConstants.experience.asMap().entries.map((e) => FadeInLeft(
              delay: Duration(milliseconds: e.key * 120),
              child: _TimelineItem(
                title: e.value['role']!,
                sub: e.value['company']!,
                period: e.value['period']!,
                desc: e.value['desc']!,
                isDark: isDark,
                isLast: e.key == AppConstants.experience.length - 1,
              ),
            )),
      ],
    );
  }
}

class _EducationSection extends StatelessWidget {
  final bool isDark;
  const _EducationSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(context, 'Education'),
        const SizedBox(height: 28),
        ...AppConstants.education.asMap().entries.map((e) => FadeInLeft(
              delay: Duration(milliseconds: e.key * 120),
              child: _TimelineItem(
                title: e.value['degree']!,
                sub: e.value['school']!,
                period: e.value['period']!,
                desc: e.value['desc']!,
                isDark: isDark,
                isLast: e.key == AppConstants.education.length - 1,
              ),
            )),
      ],
    );
  }
}

Widget _heading(BuildContext context, String text) => Row(
      children: [
        Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: AppColors.heroGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(2),
            )),
        const SizedBox(width: 12),
        Text(text, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );

class _TimelineItem extends StatelessWidget {
  final String title, sub, period, desc;
  final bool isDark, isLast;

  const _TimelineItem({
    required this.title,
    required this.sub,
    required this.period,
    required this.desc,
    required this.isDark,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.heroGradient),
              shape: BoxShape.circle,
            ),
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.6),
                    AppColors.primary.withOpacity(0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
        ]),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Row(children: [
                  Text(sub,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(period,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(desc,
                    style: TextStyle(
                        color:
                            isDark ? Colors.white60 : AppColors.textMutedLight,
                        height: 1.6,
                        fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
