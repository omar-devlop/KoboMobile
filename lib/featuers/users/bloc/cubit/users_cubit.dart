import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/data/services/kobo_service.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState.loading(msg: '')) {
    getSavedUsers();
  }
  void safeEmit(UsersState state) => !isClosed ? emit(state) : null;
  List<String> usersList = [];
  getSavedUsers() async {
    usersList = await PreferencesService.getStringList(Constants.koboUsersKeys);
    if (usersList.isEmpty) {
      safeEmit(UsersState.empty());
    } else {
      safeEmit(UsersState.savedUsers(data: usersList));
    }
  }

  onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    List<String> newList =
        List.from(usersList)
          ..removeAt(oldIndex)
          ..insert(newIndex, usersList[oldIndex]);

    PreferencesService.setData(Constants.koboUsersKeys, newList);
    usersList = newList;
    safeEmit(UsersState.savedUsers(data: newList));
  }

  Future<bool> clearSavedUsers() async {
    usersList = await PreferencesService.getStringList(Constants.koboUsersKeys);
    if (usersList.isNotEmpty) {
      for (var element in usersList) {
        await PreferencesService.removeData(element);
      }
    }
    await PreferencesService.removeData(Constants.koboUsersKeys);
    return true;
  }

  savedUserLogin({required String userName}) async {
    safeEmit(UsersState.logging(data: usersList, userName: userName));
    String userPass = await PreferencesService.getSecuredString(userName);
    if (userPass.isEmpty) return false;

    DioFactory.setSavedCredentialsIntoHeader(userPass: userPass);

    dynamic isAuth = await getIt<KoboService>().fetchUserDetails();

    if (isAuth is String || (isAuth is bool && !isAuth)) {
      DioFactory.removeCredentialsIntoHeader();
      return false;
    }

    return true;
  }
}
