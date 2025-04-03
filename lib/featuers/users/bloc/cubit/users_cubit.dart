import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/featuers/users/model/account.dart';
import 'package:kobo/featuers/users/model/account_repository.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState.loading(msg: '')) {
    getSavedAccounts();
  }
  void safeEmit(UsersState state) => !isClosed ? emit(state) : null;
  List<Account> accountsList = [];
  AccountRepository accountRepo = getIt<AccountRepository>();

  getSavedAccounts() async {
    accountsList = await accountRepo.getSavedAccountsList();
    if (accountsList.isEmpty) {
      safeEmit(UsersState.empty());
    } else {
      safeEmit(UsersState.savedUsers(data: accountsList));
    }
  }

  onReorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    List<Account> newList =
        List.from(accountsList)
          ..removeAt(oldIndex)
          ..insert(newIndex, accountsList[oldIndex]);

    accountsList = newList;
    accountRepo.saveAllAccounts(accountsList);
    safeEmit(UsersState.savedUsers(data: accountsList));
  }

  Future<bool> clearSavedAccounts() async {
    return await accountRepo.removeSavedAccounts();
  }

  Future<bool> savedAccountLogin(Account account) async {
    safeEmit(
      UsersState.logging(data: accountsList, userName: account.username),
    );
    account.password = await accountRepo.getAccountSavedPassword(account);
    KoboService koboService = getIt<KoboService>();

    DioFactory.setCredentialsIntoHeader(
      username: account.username,
      password: account.password,
    );
    koboService.setServer(url: account.serverUrl);

    dynamic isAuth = await koboService.fetchUserDetails();

    if (isAuth is String || (isAuth is bool && !isAuth)) {
      DioFactory.removeCredentialsIntoHeader();
      return false;
    }

    return true;
  }
}
