import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/widgets/group_widget.dart';
import 'package:xstock/modules/settings/pages/settings_page.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/display/display_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  late Stream<QuerySnapshot> groupsStream;

  List<GroupModel> groups = [];

  @override
  void initState() {
    super.initState();
    groupsStream = FirebaseFirestore.instance
        .collection('groups')
        .where('user_id',
            isEqualTo: userAccountRepository.getUserFromDb().user_id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
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
                          });
                    },
                    icon:
                        SvgPicture.asset("assets/images/svg/ic_add_group.svg")),
                IconButton(
                    onPressed: () {
                      NavRouter.pushWithAnimation(context, SettingsPage());
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
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: groupsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            title: a['group_name'],
                            isExpandable: a['is_extendable']));
                      }).toList();
                      return ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            return GroupWidget(
                              groupModel: groups[index],
                              onClick: () {
                                groups[index].isExpandable = !groups[index].isExpandable;
                                updateGroupItem(groups[index].isExpandable, groups[index].id);
                              },
                            );
                          });
                    })),
          ],
        ),
      ),
    );
  }

  Future<void> updateGroupItem(bool isExpandable, String id) {
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');
    return groups.doc(id)
        .update({'is_extendable': isExpandable})
        .then((value) {})
        .catchError((error) {
      DisplayUtils.showErrorToast(context, error.message);
    });
  }
}
