import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/domain/repositories/accounts_repository.dart';

class GetUser {
  final AccountsRepository _repository;
  GetUser(this._repository);

  Future<KoboUser?> call() {
    return _repository.getUser();
  }
}


