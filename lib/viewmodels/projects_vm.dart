import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../providers/portfolio_providers.dart';

// ── State ─────────────────────────────────────────────────────────────────────
class ProjectsState {
  final List<ProjectModel> projects;
  final String? selectedFilter;
  final bool isLoading;

  const ProjectsState({
    this.projects = const [],
    this.selectedFilter,
    this.isLoading = false,
  });

  ProjectsState copyWith({
    List<ProjectModel>? projects,
    String? selectedFilter,
    bool? isLoading,
    bool clearFilter = false,
  }) =>
      ProjectsState(
        projects: projects ?? this.projects,
        selectedFilter:
            clearFilter ? null : (selectedFilter ?? this.selectedFilter),
        isLoading: isLoading ?? this.isLoading,
      );
}

// ── ViewModel ─────────────────────────────────────────────────────────────────
class ProjectsViewModel extends StateNotifier<ProjectsState> {
  final List<ProjectModel> _allProjects;

  ProjectsViewModel(this._allProjects)
      : super(ProjectsState(projects: _allProjects));

  void filterByTech(String? tech) {
    if (tech == null || tech == state.selectedFilter) {
      // Clear filter
      state = state.copyWith(projects: _allProjects, clearFilter: true);
    } else {
      final filtered = _allProjects
          .where((p) =>
              p.techStack.any((t) => t.toLowerCase() == tech.toLowerCase()))
          .toList();
      state = state.copyWith(projects: filtered, selectedFilter: tech);
    }
  }

  void clearFilter() {
    state = state.copyWith(projects: _allProjects, clearFilter: true);
  }

  List<String> get availableFilters {
    final Set<String> techs = {};
    for (final p in _allProjects) {
      techs.addAll(p.techStack);
    }
    return techs.toList()..sort();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final projectsVMProvider =
    StateNotifierProvider<ProjectsViewModel, ProjectsState>((ref) {
  final projects = ref.watch(projectsProvider);
  return ProjectsViewModel(projects);
});
