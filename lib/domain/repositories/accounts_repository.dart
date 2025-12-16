import 'package:kobo/core/shared/models/kobo_user.dart';

/// Abstraction for account-related operations and server selection.
abstract class AccountsRepository {
  Future<void> setServerUrl(String url);

  Future<String?> getServerUrl();

  Future<KoboUser?> getUser();

  Future<bool> removeSavedAccount({
    required String username,
    required String serverUrl,
  });
}


