import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/data/services/kobo_service.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  void safeEmit(AuthState state) => !isClosed ? emit(state) : null;

  void login({required String username, required String password, bool rememberMe = false}) async {
    safeEmit(AuthState.loading(msg: 'loggingIn'.tr()));

    DioFactory.setCredentialsIntoHeader(username: username, password: password);

    dynamic isAuth = await getIt<KoboService>().fetchUserDetails();

    if (isAuth is bool && isAuth  && rememberMe) {
      _storeUser(
        credentials: DioFactory.getCredentials(
          username: username,
          password: password,
        ),
      );
    } else if (isAuth is String || (isAuth is bool && !isAuth)) {
      DioFactory.removeCredentialsIntoHeader();
      safeEmit(AuthState.error(error: isAuth.toString()));
      return;
    }

    safeEmit(AuthState.success());
    return;
  }

  void _storeUser({required String credentials}) async {
    List<String> usersList = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );
    String userName = await getIt<KoboService>().user.username;
    if (!usersList.contains(userName)) {
      usersList.add(userName);
      await PreferencesService.setData(Constants.koboUsersKeys, usersList);
    }

    await PreferencesService.setSecuredString(userName, credentials);
  }
}
