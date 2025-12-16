import 'package:kobo/infrastructure/datasources/kobo_remote_data_source.dart';
import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/domain/repositories/accounts_repository.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final KoboRemoteDataSource _remote;
  String? _serverUrl;
  KoboUser? _cachedUser;
  AccountsRepositoryImpl(this._remote);

  @override
  Future<KoboUser?> getUser() async {
    if (_cachedUser != null) return _cachedUser;
    try {
      final response = await _remote.getMe();
      if (response.statusCode == 200) {
        _cachedUser = KoboUser.fromJson(response.data);
        return _cachedUser;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getServerUrl() async {
    return _serverUrl;
  }

  @override
  Future<void> setServerUrl(String url) async {
    _serverUrl = url;
    _remote.setBaseUrl(url);
  }

  @override
  Future<bool> removeSavedAccount({
    required String username,
    required String serverUrl,
  }) async {
    // Placeholder: in the legacy app, removal is delegated elsewhere.
    _cachedUser = null;
    return true;
  }
}
