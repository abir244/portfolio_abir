import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Breakpoints ───────────────────────────────────────────────────────────────
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

class ResponsiveLayout {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < Breakpoints.mobile;
  static bool isTablet(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= Breakpoints.mobile &&
      MediaQuery.of(ctx).size.width < Breakpoints.tablet;
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= Breakpoints.tablet;

  /// Returns a value based on screen width.
  static T value<T>(BuildContext ctx,
      {required T mobile, required T tablet, required T desktop}) {
    if (isDesktop(ctx)) return desktop;
    if (isTablet(ctx)) return tablet;
    return mobile;
  }

  /// Horizontal content padding that grows with screen width.
  static EdgeInsets pagePadding(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w >= Breakpoints.desktop)
      return const EdgeInsets.symmetric(horizontal: 160, vertical: 40);
    if (w >= Breakpoints.tablet)
      return const EdgeInsets.symmetric(horizontal: 80, vertical: 32);
    return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
  }

  /// Max content width for large screens.
  static double maxContentWidth(BuildContext ctx) {
    return MediaQuery.of(ctx).size.width >= Breakpoints.desktop
        ? 1280
        : double.infinity;
  }

  /// Number of grid columns for project cards.
  static int projectGridColumns(BuildContext ctx) {
    if (isDesktop(ctx)) return 3;
    if (isTablet(ctx)) return 2;
    return 1;
  }
}

// ── URL Launcher ──────────────────────────────────────────────────────────────
Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    if (kIsWeb) {
      // Flutter Web: must use '_blank' to open a new browser tab
      await launchUrl(uri, webOnlyWindowName: '_blank');
      return;
    }
    // Mobile / Desktop
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  } catch (e) {
    debugPrint('launchURL error: $e');
  }
}

// ── Formatters ────────────────────────────────────────────────────────────────
String obfuscateEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final name = parts[0];
  final domain = parts[1];
  final masked = name.length > 2
      ? '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}'
      : name;
  return '$masked@$domain';
}

// ── Snack helper ──────────────────────────────────────────────────────────────
void showSnack(BuildContext ctx, String message, {bool isError = false}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
