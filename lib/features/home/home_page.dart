import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/features/projects/project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constants.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/utils.dart';
import '../../providers/portfolio_providers.dart';

import '../../widgets/skill_chip.dart';
import '../about/about_page.dart';
import '../contact/contact_page.dart';
import '../projects/projects_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final scrolled = _scrollCtrl.offset > 50;
      if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _navigate(Widget page) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          // ── Scrollable content ────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                const SizedBox(height: 80), // space for nav
                _HeroSection(onNavigate: _navigate),
                _SkillsSection(),
                _FeaturedProjectsSection(onNavigate: _navigate),
                _CTASection(onNavigate: _navigate),
                _FooterSection(),
              ],
            ),
          ),

          // ── Floating Nav bar ──────────────────────────────────────
          _NavBar(
            isScrolled: _isScrolled,
            isDark: isDark,
            onNavigate: _navigate,
            onThemeToggle: () =>
                ref.read(themeModeProvider.notifier).state = !isDark,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final bool isScrolled;
  final bool isDark;
  final void Function(Widget) onNavigate;
  final VoidCallback onThemeToggle;

  const _NavBar({
    required this.isScrolled,
    required this.isDark,
    required this.onNavigate,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 70,
      decoration: BoxDecoration(
        color: isScrolled
            ? (isDark
                ? AppColors.darkSurface.withOpacity(0.95)
                : Colors.white.withOpacity(0.95))
            : Colors.transparent,
        boxShadow: isScrolled
            ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]
            : null,
        border: isScrolled
            ? Border(
                bottom: BorderSide(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder))
            : null,
      ),
      child: Padding(
        padding:
            ResponsiveLayout.pagePadding(context).copyWith(top: 0, bottom: 0),
        child: Row(
          children: [
            // Logo
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.heroGradient,
              ).createShader(bounds),
              child: Text(
                'AM.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              _NavItem(label: 'About', page: const AboutPage()),
              _NavItem(label: 'Projects', page: const ProjectsPage()),
              _NavItem(label: 'Contact', page: const ContactPage()),
              const SizedBox(width: 8),
            ],
            // Theme toggle
            IconButton(
              onPressed: onThemeToggle,
              icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? Colors.white70 : AppColors.textDark),
              tooltip: 'Toggle theme',
            ),
            if (isMobile)
              _MobileMenuButton(onNavigate: (Widget p) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => p),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final Widget page;
  const _NavItem({required this.label, required this.page});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.page,
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: _hovered
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : AppColors.textDark),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final void Function(Widget) onNavigate;
  const _MobileMenuButton({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.menu_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (_) => [
        PopupMenuItem(value: 0, child: const Text('About')),
        PopupMenuItem(value: 1, child: const Text('Projects')),
        PopupMenuItem(value: 2, child: const Text('Contact')),
      ],
      onSelected: (idx) {
        final pages = [
          const AboutPage(),
          const ProjectsPage(),
          const ContactPage()
        ];
        onNavigate(pages[idx]);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final void Function(Widget) onNavigate;
  const _HeroSection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final padding = ResponsiveLayout.pagePadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.85,
        maxWidth: 1280,
      ),
      padding: padding,
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _HeroText(onNavigate: onNavigate)),
                Expanded(flex: 2, child: _HeroAvatar()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroAvatar(mobile: true),
                const SizedBox(height: 32),
                _HeroText(onNavigate: onNavigate),
              ],
            ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final void Function(Widget) onNavigate;
  const _HeroText({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: AppColors.heroGradient),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  '👋 Available for hire',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        FadeInDown(
          delay: const Duration(milliseconds: 150),
          duration: const Duration(milliseconds: 700),
          child: Text(
            'Hi, I\'m\n${AppConstants.appName}',
            style: tt.displayMedium!.copyWith(
              fontSize: isMobile ? 36 : 52,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),

        FadeInDown(
          delay: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 700),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                const LinearGradient(colors: AppColors.heroGradient)
                    .createShader(bounds),
            child: Text(
              AppConstants.appTitle,
              style: tt.headlineMedium!.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 20 : 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        FadeInDown(
          delay: const Duration(milliseconds: 350),
          duration: const Duration(milliseconds: 700),
          child: Text(
            AppConstants.appSubtitle,
            style:
                tt.bodyLarge!.copyWith(color: AppColors.textMuted, height: 1.7),
          ),
        ),
        const SizedBox(height: 36),

        FadeInUp(
          delay: const Duration(milliseconds: 450),
          duration: const Duration(milliseconds: 600),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => onNavigate(const ProjectsPage()),
                icon: const Icon(Icons.work_outline_rounded, size: 18),
                label: const Text('View Projects'),
              ),
              OutlinedButton.icon(
                onPressed: () => onNavigate(const ContactPage()),
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                label: const Text('Get in Touch'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Social row
        FadeInUp(
          delay: const Duration(milliseconds: 550),
          duration: const Duration(milliseconds: 600),
          child: Row(
            children: [
              _SocialIcon(
                  icon: FontAwesomeIcons.github, url: AppConstants.githubUrl),
              _SocialIcon(
                  icon: FontAwesomeIcons.linkedin,
                  url: AppConstants.linkedinUrl),
              _SocialIcon(
                  icon: FontAwesomeIcons.twitter, url: AppConstants.twitterUrl),
              _SocialIcon(
                  icon: FontAwesomeIcons.dribbble,
                  url: AppConstants.dribbbleUrl),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchURL(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.primary : AppColors.darkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.darkBorder,
            ),
          ),
          child: FaIcon(widget.icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  final bool mobile;
  const _HeroAvatar({this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Center(
        child: Container(
          width: mobile ? 160 : 320,
          height: mobile ? 160 : 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: mobile ? 24 : 48,
                spreadRadius: mobile ? 4 : 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'AM',
              style: TextStyle(
                color: Colors.white,
                fontSize: mobile ? 52 : 100,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKILLS SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _SkillsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    final padding = ResponsiveLayout.pagePadding(context);

    return Container(
      width: double.infinity,
      padding: padding.copyWith(top: 80, bottom: 80),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: 'What I work with'),
            const SizedBox(height: 8),
            Text(
              'Technologies & Tools',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills
                  .asMap()
                  .entries
                  .map((e) => SkillChip(
                        label: e.value,
                        isAnimated: true,
                        animationDelay: e.key * 60,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURED PROJECTS
// ─────────────────────────────────────────────────────────────────────────────
class _FeaturedProjectsSection extends ConsumerWidget {
  final void Function(Widget) onNavigate;
  const _FeaturedProjectsSection({required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredProjectsProvider);
    final padding = ResponsiveLayout.pagePadding(context);
    final cols = ResponsiveLayout.projectGridColumns(context);

    return Container(
      width: double.infinity,
      padding: padding.copyWith(top: 80, bottom: 80),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : const Color(0xFFF0F0FF),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(label: 'Portfolio'),
                      const SizedBox(height: 8),
                      Text('Featured Projects',
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => onNavigate(const ProjectsPage()),
                  icon: const Text('All Projects'),
                  label: const Icon(Icons.arrow_forward_rounded, size: 18),
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _ResponsiveGrid(
              columns: cols,
              children: featured.map((p) => ProjectCard(project: p)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _CTASection extends StatelessWidget {
  final void Function(Widget) onNavigate;
  const _CTASection({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(60),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF9D44FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 48,
                offset: const Offset(0, 16),
              )
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Let's work together!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Have a project in mind? I'd love to bring your ideas to life.",
                style:
                    TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => onNavigate(const ContactPage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Start a Conversation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────────────────────────
class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
            top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) =>
                const LinearGradient(colors: AppColors.heroGradient)
                    .createShader(b),
            child: const Text(
              'Abir Molla',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Abir Molla. Built with Flutter ❤️',
            style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.textMutedLight,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: AppColors.heroGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(2),
            )),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  const _ResponsiveGrid({required this.columns, required this.children});

  @override
  Widget build(BuildContext context) {
    if (columns == 1) {
      return Column(
        children: children
            .map((c) =>
                Padding(padding: const EdgeInsets.only(bottom: 24), child: c))
            .toList(),
      );
    }
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final rowChildren =
          children.sublist(i, (i + columns).clamp(0, children.length));
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren
              .asMap()
              .entries
              .map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: e.key > 0 ? 12 : 0,
                          right: e.key < rowChildren.length - 1 ? 12 : 0),
                      child: e.value,
                    ),
                  ))
              .toList(),
        ),
      ));
    }
    return Column(children: rows);
  }
}
