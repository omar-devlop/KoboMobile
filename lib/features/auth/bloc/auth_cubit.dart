import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/features/users/model/account.dart';
import 'package:kobo/features/users/model/account_repository.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.initial());

  void safeEmit(AuthState state) => !isClosed ? emit(state) : null;

  void login(Account account, {bool rememberMe = false}) async {
    safeEmit(AuthState.loading(msg: 'loggingIn'.tr()));

    DioFactory.setCredentialsIntoHeader(
      username: account.username,
      password: account.password,
    );
    KoboService koboService = getIt<KoboService>();
    koboService.setServer(url: account.serverUrl);
    dynamic isAuth = await getIt<KoboService>().fetchUserDetails();

    if (isAuth is bool && isAuth && rememberMe) {
      AccountRepository accountRepo = getIt<AccountRepository>();
      accountRepo.saveAccount(account);
    } else if (isAuth is String || (isAuth is bool && !isAuth)) {
      DioFactory.removeCredentialsIntoHeader();
      safeEmit(AuthState.error(error: isAuth.toString()));
      return;
    }

    safeEmit(const AuthState.success());
    return;
  }
}
