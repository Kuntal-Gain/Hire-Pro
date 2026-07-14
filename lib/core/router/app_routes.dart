final class AppRoutes {
  const AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Splash
  static const String splash = '/splash';

  // Applicant
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetails = '/jobs/:id';
  static const String profile = '/profile';

  // Employer
  static const String employerDashboard = '/employer';
  static const String createJob = '/employer/create-job';
  static const String manageJobs = '/employer/jobs';
}
