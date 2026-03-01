import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

class SkillChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isAnimated;
  final int animationDelay; // ms
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.isAnimated = false,
    this.animationDelay = 0,
    this.onTap,
  });

  @override
  State<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<SkillChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    if (widget.isAnimated) {
      Future.delayed(Duration(milliseconds: widget.animationDelay), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: child,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor:
            widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? const LinearGradient(
                      colors: AppColors.heroGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.isSelected
                  ? null
                  : _hovered
                      ? AppColors.primary.withOpacity(0.15)
                      : dark
                          ? AppColors.darkCard
                          : AppColors.lightBg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.transparent
                    : _hovered
                        ? AppColors.primary
                        : dark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isSelected
                    ? Colors.white
                    : _hovered
                        ? AppColors.primary
                        : dark
                            ? Colors.white70
                            : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
