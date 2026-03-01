import '../../models/project_model.dart';

class AppConstants {
  // ── Personal Info ──────────────────────────────────────────────
  static const String appName = 'Abir Molla';
  static const String appTitle =
      'Junior Full Stack Developer (Flutter + Node.js)';
  static const String appSubtitle =
      'I build production-ready mobile apps\nand scalable backend APIs.';
  static const String email = 'mollahabir008@gmail.com';
  static const String phone = '+880 1937-789081';
  static const String location = 'Dhaka, Bangladesh';

  static const String githubUrl = 'https://github.com/abir244';
  static const String linkedinUrl =
      'https://linkedin.com/in/abir-mollah-6153ab332';
  static const String twitterUrl = 'https://twitter.com/';
  static const String dribbbleUrl = 'https://dribbble.com/';

  // ── Bio ────────────────────────────────────────────────────────
  static const String bio = '''
Results-driven Junior Full Stack Developer with hands-on experience building 
and deploying production-ready mobile applications and RESTful backend APIs.

Specialized in Flutter, Node.js, and MongoDB. Proven track record in 
implementing Clean Architecture, secure JWT authentication, and robust 
database modeling — from MVP conception to stable production release.
''';

  // ── Skills ─────────────────────────────────────────────────────
  static const List<String> skills = [
    'Flutter',
    'Dart',
    'Node.js',
    'Express.js',
    'MongoDB',
    'Firebase',
    'Riverpod',
    'Provider',
    'REST APIs',
    'JWT Auth',
    'MySQL',
    'SQLite',
    'Git & GitHub',
    'Postman',
    'HTML5 & CSS3',
    'Clean Architecture',
    'MVVM / MVC',
    'Railway',
    'FCM',
    'Agile',
  ];

  // ── Experience ─────────────────────────────────────────────────
  static const List<Map<String, String>> experience = [
    {
      'role': 'Software Developer & QA Tester',
      'company': 'Softvence, Dhaka',
      'period': 'Oct 2025 – Present',
      'desc':
          'Engineer cross-platform Flutter apps at 60 FPS. Architect modular Node.js/Express backends with RBAC and JWT security. Lead QA initiatives using Postman, reducing production bugs by 25%.',
    },
    {
      'role': 'App Developer Intern',
      'company': '9AM Solutions, Dhaka',
      'period': 'Jan 2025 – Jun 2025',
      'desc':
          'Developed 15+ high-fidelity Flutter UI screens from Figma designs. Integrated third-party REST APIs and managed local data persistence using SQLite. Optimised load times with efficient state management and lazy-loading.',
    },
  ];

  // ── Education ──────────────────────────────────────────────────
  static const List<Map<String, String>> education = [
    {
      'degree': 'B.Sc. in Computer Science & Engineering',
      'school': 'Green University of Bangladesh',
      'period': '2021 – 2025',
      'desc':
          'Thesis: Cross-Modal Deepfake Detection Using Deep Learning and NLP.',
    },
    {
      'degree': 'Competitive Programming',
      'school': 'Codeforces · LeetCode',
      'period': 'Ongoing',
      'desc':
          'Solved 200+ problems across online judges. Strong grasp of Dynamic Programming, Graph Theory, and Greedy Algorithms.',
    },
  ];

  // ── Projects ───────────────────────────────────────────────────
  static final List<ProjectModel> projects = [
    ProjectModel(
      title: 'AI Studio',
      description:
          'A scalable full-stack AI chat application with real-time AI integration via REST APIs, Bcrypt password hashing, session-based JWT tokens, and Firebase Cloud Messaging push notifications.',
      techStack: ['Flutter', 'Node.js', 'MongoDB', 'Firebase', 'JWT'],
      imageUrl:
          'https://images.unsplash.com/photo-1676299081847-824916de030a?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: true,
    ),
    ProjectModel(
      title: 'Flutter E-Commerce App',
      description:
          'A cross-platform e-commerce app with 60 FPS performance, clean architecture, Riverpod state management, and a Node.js/Express REST backend with secure product and order management.',
      techStack: ['Flutter', 'Riverpod', 'Node.js', 'MongoDB'],
      imageUrl:
          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: true,
    ),
    ProjectModel(
      title: 'Task Manager API',
      description:
          'A RESTful task management backend with centralized error handling, role-based access control (RBAC), JWT authentication, middleware layers, and full CRUD operations via Express.js.',
      techStack: ['Node.js', 'Express.js', 'MongoDB', 'JWT'],
      imageUrl:
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: true,
    ),
    ProjectModel(
      title: 'Weather App',
      description:
          'A Flutter weather application fetching real-time data from OpenWeather API with animated UI, geolocation, 7-day forecasts, and efficient Provider state management.',
      techStack: ['Flutter', 'REST APIs', 'Provider', 'Dart'],
      imageUrl:
          'https://images.unsplash.com/photo-1504608524841-42584120d290?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: false,
    ),
    ProjectModel(
      title: 'Auth System',
      description:
          'Secure user authentication system built with Node.js/Express, Bcrypt password hashing, JWT refresh tokens, middleware validation layers, and MongoDB user management.',
      techStack: ['Node.js', 'Express.js', 'MongoDB', 'JWT'],
      imageUrl:
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: false,
    ),
    ProjectModel(
      title: 'Deepfake Detection',
      description:
          'Final-year thesis: a cross-modal deepfake detection system using Deep Learning and NLP techniques to identify manipulated video and audio content with high accuracy.',
      techStack: ['Python', 'Deep Learning', 'NLP', 'TensorFlow'],
      imageUrl:
          'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600&q=80',
      liveUrl: 'https://github.com/abir244',
      githubUrl: 'https://github.com/abir244',
      isFeatured: false,
    ),
  ];
}
