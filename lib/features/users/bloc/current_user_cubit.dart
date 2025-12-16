import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/domain/usecases/accounts/get_user.dart';

class CurrentUserCubit extends Cubit<KoboUser?> {
  final GetUser _getUser;
  CurrentUserCubit(this._getUser) : super(null);

  Future<void> load() async {
    try {
      final user = await _getUser();
      emit(user);
    } catch (_) {
      emit(null);
    }
  }
}


