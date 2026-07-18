class Tables {
  Tables._();
  static const users = 'users';
  static const candidates = 'applicant_data';
  static const employers = 'employers';
  static const jobs = 'jobs';
  static const applications = 'applications';
  static const skills = 'skills';
  static const screeningQuestions = 'screening_questions';
  static const screeningAnswers = 'screening_answers';
}

class Buckets {
  Buckets._();
  static const profile = 'profile';
  static const certifications = 'certifications';
  static const resumes = 'resumes';
  static const companyLogos = 'company-logos';
}

class SupabaseRpc {
  SupabaseRpc._();
  static const computeMatchScore = 'compute_match_score';
  static const getRankedCandidates = 'get_ranked_candidates_for_job';
}
