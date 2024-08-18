import 'package:bloc/bloc.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/models/group_model.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsState.initial());

  List<GroupModel> groups =[];
  List<GroupModel> filterGroups = [];

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

  void updateExtendableSelection(String id){
    var group = groups.firstWhere((element) => element.id == id);
    group.isExpandable = !group.isExpandable;
    emit(state.copyWith(groups:  groups));
  }
  void clearGroups(){
    groups = [];
  }
  void initialList(List<GroupModel> list){
    groups = list;
    emit(state.copyWith(groups:  groups));
  }

  void filterSearchResults(String query) {
    filterGroups = groups
        .where((item) => item.name
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(
        groups:filterGroups
    ));
  }
}
