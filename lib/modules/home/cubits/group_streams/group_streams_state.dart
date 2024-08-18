import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xstock/modules/home/models/group_model.dart';

enum GroupStreamsStatus { initial }

class GroupStreamsState {
  final bool hasData;
  final Stream<QuerySnapshot>? groupsStream;

  GroupStreamsState({required this.groupsStream, required this.hasData});

  factory GroupStreamsState.initial() {
    return GroupStreamsState(
      groupsStream: null,
      hasData: false
    );
  }

  GroupStreamsState copyWith({
    Stream<QuerySnapshot>? groupsStream,
    bool? hasData,
  }) {
    return GroupStreamsState(
        groupsStream: groupsStream ?? this.groupsStream,
      hasData: hasData?? this.hasData
    );
  }
}
