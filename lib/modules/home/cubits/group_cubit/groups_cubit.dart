import 'package:bloc/bloc.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/models/group_model.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsState.initial());

  List<GroupModel> groups =[];
  void updateGroupSelection(String id){
    groups.forEach((element) {
      if(element.id == id) {
        element.isSelected = true;
      }else{
        element.isSelected = false;
      }
    });
    emit(state.copyWith(groups:  groups));
  }

  void initialList(List<GroupModel> list){
    groups = list;
    emit(state.copyWith(groups:  groups));
  }
}
