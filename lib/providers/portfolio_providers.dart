import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/constants.dart';
import '../models/project_model.dart';

// ── Projects provider ─────────────────────────────────────────────────────────
final projectsProvider = Provider<List<ProjectModel>>((ref) {
  return AppConstants.projects;
});

final featuredProjectsProvider = Provider<List<ProjectModel>>((ref) {
  return ref.watch(projectsProvider).where((p) => p.isFeatured).toList();
});

// ── Skills provider ───────────────────────────────────────────────────────────
final skillsProvider = Provider<List<String>>((ref) {
  return AppConstants.skills;
});

// ── Theme mode provider ───────────────────────────────────────────────────────
final themeModeProvider = StateProvider<bool>((ref) => true); // true = dark

// ── Selected nav index ────────────────────────────────────────────────────────
final navIndexProvider = StateProvider<int>((ref) => 0);
