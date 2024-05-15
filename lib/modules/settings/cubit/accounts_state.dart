import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';

enum AccountsStatus { initial }

class AccountsState {
  final List<AccountTitleModel> accounts;

  AccountsState({required this.accounts});

  factory AccountsState.initial() {
    return AccountsState(accounts: []);
  }

  AccountsState copyWith({List<AccountTitleModel>? accounts}) {
    return AccountsState(accounts: accounts ?? this.accounts);
  }
}
