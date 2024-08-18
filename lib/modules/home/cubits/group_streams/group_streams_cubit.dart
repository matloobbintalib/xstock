import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/cubits/group_streams/group_streams_state.dart';
import 'package:xstock/modules/home/models/group_model.dart';

import '../../../authentication/models/user_model.dart';

class GroupStreamsCubit extends Cubit<GroupStreamsState> {
  GroupStreamsCubit() : super(GroupStreamsState.initial());
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();

  void getGroupStreams() async {
    emit(state.copyWith(hasData: false));
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection(Endpoints.usersTable);
      UserModel userModel = await userAccountRepository.getUserFromDb();
      DocumentReference userRef = await usersCollection.doc(userModel.id);
      CollectionReference groupCollection =
          await userRef.collection(Endpoints.groupsTable);
      emit(state.copyWith(
          groupsStream: groupCollection.snapshots(), hasData: true));
    } catch (e) {
      emit(state.copyWith(hasData: false));
    }
  }
}
