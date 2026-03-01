import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/theme/theme.dart';
import 'package:flutter_portfolio/core/utils/utils.dart';
import 'package:flutter_portfolio/models/project_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final p = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.primary
                : (dark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(dark ? 0.3 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────────
            _ProjectImage(imageUrl: p.imageUrl, hovered: _hovered),

            // ── Body ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (p.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: AppColors.heroGradient),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    p.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Tech chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        p.techStack.map((t) => _TechPill(label: t)).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      _ActionButton(
                        icon: Icons.open_in_new_rounded,
                        label: 'Live Demo',
                        url: p.liveUrl,
                        filled: true,
                      ),
                      const SizedBox(width: 10),
                      _ActionButton(
                        icon: FontAwesomeIcons.github,
                        label: 'Code',
                        url: p.githubUrl,
                        filled: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ProjectImage extends StatelessWidget {
  final String imageUrl;
  final bool hovered;
  const _ProjectImage({required this.imageUrl, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedScale(
            scale: hovered ? 1.07 : 1.0,
            duration: const Duration(milliseconds: 400),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.darkCard,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.textMuted, size: 48),
              ),
            ),
          ),
          // Gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(hovered ? 0.55 : 0.35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechPill extends StatelessWidget {
  final String label;
  const _TechPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: dark ? AppColors.primaryLight : AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool filled;
  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.url,
      required this.filled});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            gradient: widget.filled
                ? LinearGradient(
                    colors: _hovered
                        ? [AppColors.primaryDark, AppColors.primary]
                        : AppColors.heroGradient,
                  )
                : null,
            color: !widget.filled
                ? (_hovered
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent)
                : null,
            borderRadius: BorderRadius.circular(10),
            border: !widget.filled
                ? Border.all(
                    color: _hovered ? AppColors.primary : AppColors.darkBorder,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 13, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
