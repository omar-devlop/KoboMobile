import 'package:flutter/widgets.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/featuers/users/model/account.dart';

class AccountRepository {
  Future<void> saveAccount(Account account) async {
    debugPrint('SAVING ---> ${account.toString()}');

    List<String> accountsList = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );
    String accountDetails = account.toJson();

    if (accountsList.contains(accountDetails)) return;
    accountsList.add(accountDetails);
    await PreferencesService.setData(Constants.koboUsersKeys, accountsList);
    await PreferencesService.setSecuredString(
      account.toKey(),
      account.password,
    );
  }

  Future<void> removeAccount(Account account) async {
    debugPrint('REMOVEING ---> ${account.toString()}');

    List<String> accountsList = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );
    String accountDetails = account.toJson();
    if (!accountsList.contains(accountDetails)) return;
    accountsList.remove(accountDetails);
    await PreferencesService.setData(Constants.koboUsersKeys, accountsList);
    await PreferencesService.removeData(account.toKey());
  }

  Future<void> saveAllAccounts(List<Account> accountsList) async {
    debugPrint('NEW_ACCOUNT_LIST --->');
    List<String> newAccountsList = [];

    for (Account account in accountsList) {
      newAccountsList.add(account.toJson());
    }
    PreferencesService.setData(Constants.koboUsersKeys, newAccountsList);
    return;
  }

  Future<List<Account>> getSavedAccountsList() async {
    debugPrint('ALL ACCOUNTS --->');

    final List<String> savedAccounts = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );

    final List<Account> accounts = savedAccounts.map(Account.fromJson).toList();

    return accounts;
  }

  Future<bool> removeSavedAccounts() async {
    debugPrint('REMOVE ACCOUNTS --->');

    final List<String> savedAccounts = await PreferencesService.getStringList(
      Constants.koboUsersKeys,
    );

    for (String savedAccount in savedAccounts) {
      Account account = Account.fromJson(savedAccount);
      await PreferencesService.removeSecuredData(account.toKey());
    }
    await PreferencesService.removeData(Constants.koboUsersKeys);

    return true;
  }

  Future<String> getAccountSavedPassword(Account account) async {
    return await PreferencesService.getSecuredString(account.toKey());
  }
}
