import 'package:xstock/modules/home/models/group_model.dart';

enum GroupsStatus { initial }

class GroupsState {
  final List<GroupModel> groups;

  GroupsState({required this.groups});

  factory GroupsState.initial() {
    return GroupsState(groups: []);
  }

  GroupsState copyWith({List<GroupModel>? groups}) {
    return GroupsState(groups: groups ?? this.groups);
  }
}
