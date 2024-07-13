class ImagePathProvider {
  static final List<String> images = [
    logoBW,
    logoPlain,
    logoWhite,
    emptyContent,
    noRecentWorkout,
    noDates,
    registerBg,
    ...periodizationImages,
  ];

  static const String logoBW = 'assets/images/icons/s&c-logo-bw.png';

  static const String logoPlain = 'assets/images/icons/logo-plain.png';

  static const String logoWhite = 'assets/images/icons/logo-white.png';

  static const String emptyContent = 'assets/images/icons/empty-content.png';

  static const String noRecentWorkout = 'assets/images/icons/no-recent-workout.png';

  static const String noDates = 'assets/images/icons/no-dates.png';

  static const String registerBg = 'assets/images/backgrounds/register_bg.png';

  static final List<String> periodizationImages = List.generate(4, (index) => 'assets/images/backgrounds/periodization$index.png', growable: false);
}
