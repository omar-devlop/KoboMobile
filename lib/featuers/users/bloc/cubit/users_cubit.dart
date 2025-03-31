import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:kobo/featuers/users/model/account.dart';
import 'package:kobo/featuers/users/model/account_repo.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState.loading(msg: '')) {
    getSavedAccounts();
  }
  void safeEmit(UsersState state) => !isClosed ? emit(state) : null;
  List<Account> accountsList = [];

  getSavedAccounts() async {
    accountsList = await AccountRepository.getSavedAccountsList();
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
    AccountRepository.saveAllAccounts(accountsList);
    safeEmit(UsersState.savedUsers(data: accountsList));
  }

  Future<bool> clearSavedAccounts() async {
    return await AccountRepository.removeSavedAccounts();
  }

  Future<bool> savedAccountLogin(Account account) async {
    safeEmit(
      UsersState.logging(data: accountsList, userName: account.username),
    );
    account.password = await account.getSavedPassword;
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
