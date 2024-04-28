class Endpoints {

  // Image URL
  // static const String imageUrl = 'https://psykee.cyberasol.com/';
  static const String imageUrl = 'http://203.175.74.162/';

  // Auth
  static const String login = '/login';
  static const String signup = '/advisor-register';
  static const String logout = '/logout';
  static const String socialSignup = '/social-signup';
  static const String check = '/check';

  // Lists
  static const String getCategories = '/categories';
  static const String getSkills = '/skills';
  static const String getTools = '/tools';
  static const String getLanguages = '/languages';
  static const String getAppointmentsList = '/appointment';
  static const String changeAppointmentStatus = '/appointment';
  static const String getWalletBalance = '/wallet-balance';
  static const String chatAttachment = '/chat-attachment';

  //General
  static const String dashboard = '/dashboard';


  //Profile
  static const String updateProfile = '/update-advisor-profile';
  static const String getProfile = '/user-profile';

  //Availability
  static const String schedule = '/schedule';
  static const String specialSchedule = '/special-schedule';

  /// Forgot Password
  static const String sendOtp = '/users/sendOtp';
  static const String verifyOtp = '/users/verifyOtp';
  static const String resetPassword = '/users/resetUserPassword';
}
