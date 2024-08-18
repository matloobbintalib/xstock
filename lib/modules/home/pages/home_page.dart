import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/api_endpoints.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/constants/constants.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_cubit.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/cubits/group_streams/group_streams_cubit.dart';
import 'package:xstock/modules/home/cubits/group_streams/group_streams_state.dart';
import 'package:xstock/modules/home/cubits/items_streams/items_streams_cubit.dart';
import 'package:xstock/modules/home/cubits/send_notification/send_notification_cubit.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/pages/add_item_page.dart';
import 'package:xstock/modules/home/widgets/group_widget.dart';
import 'package:xstock/modules/settings/pages/settings_page.dart';
import 'package:xstock/modules/user/cubits/user_cubit.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/no_data_found.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/context_user.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  const HomePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => GroupsCubit(),
)
  ],
  child: HomePageView(userModel: userModel,),
);
  }
}

class HomePageView extends StatefulWidget {
  final UserModel userModel;
  const HomePageView({super.key, required this.userModel});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  TextEditingController searchController = TextEditingController();
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  CollectionReference usersCollection = FirebaseFirestore.instance.collection(Endpoints.usersTable);
  late Stream<QuerySnapshot> groupsStream;
  List<GroupModel> groups = [];

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>()..sendNotification();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watchCurrentUser;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20) +
            EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/svg/ic_xstock_home.svg",
                  width: 150,
                  height: 40,
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: (context),
                          builder: (context) {
                            return NewGroupDialog();
                          }).then((value) {
                        context.read<UserCubit>().loadUser();
                        setState(() {});
                      });
                    },
                    icon:
                    SvgPicture.asset("assets/images/svg/ic_add_group.svg")),
                IconButton(
                    onPressed: () {
                      NavRouter.pushWithAnimation(context, SettingsPage())
                          .then((value) {
                        context.read<UserCubit>().loadUser();
                        setState(() {});
                      });
                    },
                    icon:
                    SvgPicture.asset("assets/images/svg/ic_settings.svg")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InputField(
              controller: searchController,
              label: 'Search item...',
              textInputAction: TextInputAction.done,
              borderRadius: 16,
              verticalPadding: 20,
              fillColor: AppColors.fieldColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              boxConstraints: 60,
              hintColor: Colors.white,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: SvgPicture.asset(
                  "assets/images/svg/ic_search.svg",
                ),
              ),
              onChange: (String value) {
                print(value);
                context.read<GroupsCubit>().filterSearchResults(value);
              },
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: usersCollection.doc(user.id).collection(Endpoints.groupsTable).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularLoadingIndicator(),
                        );
                      }
                      groups.clear();
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map a = document.data() as Map<String, dynamic>;
                        groups.add(GroupModel(
                            id: document.id,
                            userId: a['user_id'],
                            name: a[Endpoints.groupName],
                            createdAt: a['created_at'],
                            isExpandable: true,
                            isSelected: false));
                      }).toList();
                      groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                      context.read<GroupsCubit>().clearGroups();
                      context.read<GroupsCubit>().initialList(groups);
                      return BlocBuilder<GroupsCubit, GroupsState>(
                        builder: (context, state) {
                          if (state.groups.isEmpty) {
                            return NoDataFound();
                          } else {
                            return ListView.builder(
                                itemCount: state.groups.length,
                                itemBuilder: (context, index) {
                                  return GroupWidget(
                                    groupModel: state.groups[index],
                                    onClick: () {
                                      context
                                          .read<GroupsCubit>()
                                          .updateExtendableSelection(state
                                          .groups[index].id
                                          .toString());
                                    },
                                    onAddItem: (String groupId) {
                                      NavRouter.push(
                                          context,
                                          AddItemPage(
                                            groupId: groupId,
                                            userModel: user,
                                          )).then((value) {
                                        context.read<UserCubit>().loadUser();
                                        setState(() {});
                                      });
                                    },
                                    userModel: user,
                                  );
                                });
                          }
                        },
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
