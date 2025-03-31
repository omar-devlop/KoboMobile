import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/preferences_service.dart';

class KoboUser {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String serverTime;
  final String dateJoined;
  final String projectsUrl;
  final bool isSuperuser;
  final String gravatar;
  final bool isStaff;
  final String lastLogin;
  final ExtraDetails extraDetails;
  final dynamic gitRev;
  final List<dynamic> socialAccounts;
  final bool validatedPassword;
  final bool acceptedTos;

  KoboUser({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.serverTime,
    required this.dateJoined,
    required this.projectsUrl,
    required this.isSuperuser,
    required this.gravatar,
    required this.isStaff,
    required this.lastLogin,
    required this.extraDetails,
    required this.gitRev,
    required this.socialAccounts,
    required this.validatedPassword,
    required this.acceptedTos,
  });

  factory KoboUser.fromJson(Map<String, dynamic> json) => KoboUser(
    username: json['username'] ?? '',
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    email: json['email'] ?? '',
    serverTime: json['server_time'] ?? '',
    dateJoined: json['date_joined'] ?? '',
    projectsUrl: json['projects_url'] ?? '',
    isSuperuser: json['is_superuser'] as bool,
    gravatar: json['gravatar'] ?? '',
    isStaff: json['is_staff'] as bool,
    lastLogin: json['last_login'] ?? '',
    extraDetails: ExtraDetails.fromJson(
      json['extra_details'] as Map<String, dynamic>,
    ),
    gitRev: json['git_rev'],
    socialAccounts: json['social_accounts'] as List<dynamic>,
    validatedPassword: json['validated_password'] as bool,
    acceptedTos: json['accepted_tos'] as bool,
  );
  Future<bool> removeSavedAccount() async {
    await PreferencesService.removeData(username);
    List<String> usersList = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );
    usersList.remove(username);

    await PreferencesService.setData(Constants.koboUsersKeys, usersList);

    await PreferencesService.removeSecuredData(username);

    return true;
  }
}

class ExtraDetails {
  final String bio;
  final String city;
  final String name;
  final String gender;
  final String sector;
  final String country;
  final String twitter;
  final String linkedin;
  final String instagram;
  final String organization;
  final bool requireAuth;
  final String lastUiLanguage;
  final String organizationType;
  final String organizationWebsite;
  final ProjectViewsSettings? projectViewsSettings;
  final String newsletterSubscription;

  ExtraDetails({
    required this.bio,
    required this.city,
    required this.name,
    required this.gender,
    required this.sector,
    required this.country,
    required this.twitter,
    required this.linkedin,
    required this.instagram,
    required this.organization,
    required this.requireAuth,
    required this.lastUiLanguage,
    required this.organizationType,
    required this.organizationWebsite,
    required this.projectViewsSettings,
    required this.newsletterSubscription,
  });

  factory ExtraDetails.fromJson(Map<String, dynamic> json) => ExtraDetails(
    bio: json['bio'] ?? '',
    city: json['city'] ?? '',
    name: json['name'] ?? '',
    gender: json['gender'] ?? '',
    sector: json['sector'] ?? '',
    country: json['country'] ?? '',
    twitter: json['twitter'] ?? '',
    linkedin: json['linkedin'] ?? '',
    instagram: json['instagram'] ?? '',
    organization: json['organization'] ?? '',
    requireAuth: json['require_auth'] as bool,
    lastUiLanguage: json['last_ui_language'] ?? '',
    organizationType: json['organization_type'] ?? '',
    organizationWebsite: json['organization_website'] ?? '',
    projectViewsSettings:
        json['project_views_settings'] == null
            ? null
            : ProjectViewsSettings.fromJson(
              json['project_views_settings'] as Map<String, dynamic>,
            ),
    newsletterSubscription: json['newsletter_subscription'].toString(),
  );
}

class ProjectViewsSettings {
  final KoboMyProjects koboMyProjects;

  ProjectViewsSettings({required this.koboMyProjects});

  factory ProjectViewsSettings.fromJson(Map<String, dynamic> json) =>
      ProjectViewsSettings(
        koboMyProjects: KoboMyProjects.fromJson(
          json['kobo_my_projects'] as Map<String, dynamic>,
        ),
      );
}

class KoboMyProjects {
  final Map<String, dynamic> order;
  final List<String> fields;
  final List<dynamic> filters;

  KoboMyProjects({
    required this.order,
    required this.fields,
    required this.filters,
  });

  factory KoboMyProjects.fromJson(Map<String, dynamic> json) => KoboMyProjects(
    order: json['order'] as Map<String, dynamic>,
    fields: (json['fields'] as List<dynamic>).map((e) => e as String).toList(),
    filters: json['filters'] as List<dynamic>,
  );
}
