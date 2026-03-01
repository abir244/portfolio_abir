import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/features/projects/project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/utils.dart';
import '../../viewmodels/projects_vm.dart';
import '../../widgets/skill_chip.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsVMProvider);
    final vm = ref.read(projectsVMProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final padding = ResponsiveLayout.pagePadding(context);
    final cols = ResponsiveLayout.projectGridColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) =>
              const LinearGradient(colors: AppColors.heroGradient)
                  .createShader(b),
          child: const Text('Projects',
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
                  // Header
                  FadeInDown(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Portfolio'),
                        const SizedBox(height: 10),
                        Text('All Projects',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 12),
                        Text(
                          'A collection of projects I\'ve built — from mobile apps to full-stack platforms.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Filter chips
                  FadeInDown(
                    delay: const Duration(milliseconds: 150),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SkillChip(
                            label: 'All',
                            isSelected: state.selectedFilter == null,
                            onTap: vm.clearFilter,
                          ),
                          const SizedBox(width: 8),
                          ...vm.availableFilters.map((tech) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SkillChip(
                                  label: tech,
                                  isSelected: state.selectedFilter == tech,
                                  onTap: () => vm.filterByTech(tech),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Count
                  Text(
                    '${state.projects.length} project${state.projects.length == 1 ? '' : 's'} found',
                    style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.textMutedLight,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // Grid
                  _ProjectGrid(columns: cols, projects: state),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Row(
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
          Text(text.toUpperCase(),
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2)),
        ],
      );
}

class _ProjectGrid extends StatelessWidget {
  final int columns;
  final ProjectsState projects;
  const _ProjectGrid({required this.columns, required this.projects});

  @override
  Widget build(BuildContext context) {
    if (projects.projects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded,
                  size: 64, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text('No projects found for this filter.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    if (columns == 1) {
      return Column(
        children: projects.projects
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: FadeInUp(
                    delay: Duration(milliseconds: e.key * 80),
                    child: ProjectCard(project: e.value),
                  ),
                ))
            .toList(),
      );
    }

    final rows = <Widget>[];
    final list = projects.projects;
    for (var i = 0; i < list.length; i += columns) {
      final slice = list.sublist(i, (i + columns).clamp(0, list.length));
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: slice
              .asMap()
              .entries
              .map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: e.key > 0 ? 12 : 0,
                        right: e.key < slice.length - 1 ? 12 : 0,
                      ),
                      child: FadeInUp(
                        delay: Duration(milliseconds: (i + e.key) * 60),
                        child: ProjectCard(project: e.value),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ));
    }
    return Column(children: rows);
  }
}
