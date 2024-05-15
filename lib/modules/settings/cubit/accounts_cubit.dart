import 'package:bloc/bloc.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/settings/cubit/accounts_state.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';

class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit() : super(AccountsState.initial());

  List<AccountTitleModel> accounts =[];
  void updateAccountSelection(String email){
    accounts.forEach((element) {
      if(element.email == email) {
        element.isSelected = true;
      }else{
        element.isSelected = false;
      }
    });
    emit(state.copyWith(accounts:  accounts));
  }

  void initialList(List<AccountTitleModel> list){
    accounts = list;
    emit(state.copyWith(accounts:  accounts));
  }
}
