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
        username: json['username'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        serverTime: json['server_time'] as String,
        dateJoined: json['date_joined'] as String,
        projectsUrl: json['projects_url'] as String,
        isSuperuser: json['is_superuser'] as bool,
        gravatar: json['gravatar'] as String,
        isStaff: json['is_staff'] as bool,
        lastLogin: json['last_login'] as String,
        extraDetails: ExtraDetails.fromJson(json['extra_details'] as Map<String, dynamic>),
        gitRev: json['git_rev'],
        socialAccounts: json['social_accounts'] as List<dynamic>,
        validatedPassword: json['validated_password'] as bool,
        acceptedTos: json['accepted_tos'] as bool,
      );
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
  final ProjectViewsSettings projectViewsSettings;
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
        bio: json['bio'] as String,
        city: json['city'] as String,
        name: json['name'] as String,
        gender: json['gender'] as String,
        sector: json['sector'] as String,
        country: json['country'] as String,
        twitter: json['twitter'] as String,
        linkedin: json['linkedin'] as String,
        instagram: json['instagram'] as String,
        organization: json['organization'] as String,
        requireAuth: json['require_auth'] as bool,
        lastUiLanguage: json['last_ui_language'] as String,
        organizationType: json['organization_type'] as String,
        organizationWebsite: json['organization_website'] as String,
        projectViewsSettings:
            ProjectViewsSettings.fromJson(json['project_views_settings'] as Map<String, dynamic>),
        newsletterSubscription: json['newsletter_subscription'] as String,
      );
}

class ProjectViewsSettings {
  final KoboMyProjects koboMyProjects;

  ProjectViewsSettings({required this.koboMyProjects});

  factory ProjectViewsSettings.fromJson(Map<String, dynamic> json) => ProjectViewsSettings(
        koboMyProjects:
            KoboMyProjects.fromJson(json['kobo_my_projects'] as Map<String, dynamic>),
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