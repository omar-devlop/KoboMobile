class Constants {
  static const String appName = 'KoboMobile';
  static const int limit = 30;
  static final Uri koboSignupUrl = Uri.parse(
    'https://www.kobotoolbox.org/sign-up/',
  );
  static final Uri telegramGroupUrl = Uri.parse('https://t.me/kobomobile');
  static const String koboUsersKeys = 'koboUsers';
  static const List<String> koboServersList = [
    'https://eu.kobotoolbox.org',
    'https://kf.kobotoolbox.org',
  ];
}
