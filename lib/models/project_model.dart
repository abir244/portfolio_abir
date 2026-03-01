class ProjectModel {
  final String title;
  final String description;
  final List<String> techStack;
  final String imageUrl;
  final String liveUrl;
  final String githubUrl;
  final bool isFeatured;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    required this.imageUrl,
    required this.liveUrl,
    required this.githubUrl,
    this.isFeatured = false,
  });

  ProjectModel copyWith({
    String? title,
    String? description,
    List<String>? techStack,
    String? imageUrl,
    String? liveUrl,
    String? githubUrl,
    bool? isFeatured,
  }) =>
      ProjectModel(
        title: title ?? this.title,
        description: description ?? this.description,
        techStack: techStack ?? this.techStack,
        imageUrl: imageUrl ?? this.imageUrl,
        liveUrl: liveUrl ?? this.liveUrl,
        githubUrl: githubUrl ?? this.githubUrl,
        isFeatured: isFeatured ?? this.isFeatured,
      );
}
