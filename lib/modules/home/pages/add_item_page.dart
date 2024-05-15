import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_cubit.dart';
import 'package:xstock/modules/home/cubits/group_cubit/groups_state.dart';
import 'package:xstock/modules/home/dialogs/color_chooser_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/models/group_name_item_model.dart';
import 'package:xstock/modules/home/widgets/group_name_item_widget.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/extensions/extended_context.dart';
import 'package:xstock/utils/validators/validators.dart';

class AddItemPage extends StatelessWidget {
  final String groupId;

  const AddItemPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit(),
      child: AddItemPageView(
        groupId: groupId,
      ),
    );
  }
}

class AddItemPageView extends StatefulWidget {
  final String groupId;

  const AddItemPageView({super.key, required this.groupId});

  @override
  State<AddItemPageView> createState() => _AddItemPageViewState();
}

class _AddItemPageViewState extends State<AddItemPageView> {
  TextEditingController itemNameController = TextEditingController();
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();
  late Stream<QuerySnapshot> groupsStream;
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  String groupId = '';

  @override
  void initState() {
    super.initState();
    groupId = widget.groupId;
    groupsStream = FirebaseFirestore.instance
        .collection('groups')
        .where('user_id',
            isEqualTo: userAccountRepository.getUserFromDb().user_id)
        .snapshots();
  }

  void addItem(String colorCode) async {
    ToastLoader.show();
    await items.add({
      'group_id': groupId,
      'color_code': colorCode,
      "item_name": itemNameController.text.trim().toString(),
      "item_count": 0
    }).then((value) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, 'Item added successfully');
      NavRouter.pop(context);
    }).onError((error, stackTrace) {
      ToastLoader.remove();
      DisplayUtils.showToast(context, error.toString());
    });
  }

  List<GroupModel> groupNameItems = [];

  Color color = AppColors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarWidget(
                    title: 'New Item',
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.all(9),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OnClick(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ColorChooserDialog(
                                    color: color,
                                    onChangeColor: (Color color) {
                                      setState(() {
                                        this.color = color;
                                      });
                                    },
                                  );
                                });
                          },
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: InputField(
                              controller: itemNameController,
                              label: 'Item name: Amount of stock',
                              borderRadius: 20,
                              horizontalPadding: 0,
                              borderColor: AppColors.fieldColor,
                              fillColor: AppColors.fieldColor,
                              keyboardType: TextInputType.name,
                              boxConstraints: 44,
                              textInputAction: TextInputAction.done),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NewGroupDialog();
                            });
                      },
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/images/svg/ic_add_item.svg"),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "New Group",
                            style: context.textTheme.bodyMedium,
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Dash(
                      dashColor: Colors.white,
                      dashThickness: .1,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Existing Groups Listed Below ",
                    style: context.textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: groupsStream,
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
                        groupNameItems.clear();
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          groupNameItems.add(GroupModel(
                              id: document.id,
                              userId: a['user_id'],
                              title: a['group_name'],
                              isSelected: widget.groupId == document.id,
                              isExpandable: a['is_extendable']));
                        }).toList();
                        context.read<GroupsCubit>().initialList(groupNameItems);
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.fieldColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: BlocBuilder<GroupsCubit, GroupsState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  itemCount: state.groups.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return OnClick(
                                        onTap: () {
                                          context
                                              .read<GroupsCubit>()
                                              .updateGroupSelection(
                                                  state.groups[index].id);
                                        },
                                        child: GroupNameItemWidget(
                                            model: state.groups[index]));
                                  });
                            },
                          ),
                        );
                      })
                ],
              )),
              Center(
                child: PrimaryButton(
                  onPressed: () {
                    if (itemNameController.text.isNotEmpty) {
                      if (context.read<GroupsCubit>().state.groups.isNotEmpty) {
                        groupId = context
                            .read<GroupsCubit>()
                            .state
                            .groups
                            .where((element) => element.isSelected)
                            .first
                            .id;
                        if (groupId.isNotEmpty) {
                          addItem(color.toString());
                        } else {
                          DisplayUtils.showErrorToast(
                              context, 'Please select a group');
                        }
                      } else {
                        DisplayUtils.showErrorToast(
                            context, 'Please add a group');
                      }
                    } else {
                      DisplayUtils.showErrorToast(
                          context, 'Please enter item count');
                    }
                  },
                  title: 'Done',
                  height: 56,
                  width: 195,
                  backgroundColor: context.colorScheme.secondary,
                  borderColor: context.colorScheme.secondary,
                  borderRadius: 28,
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
