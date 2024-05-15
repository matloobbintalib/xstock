import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/modules/settings/cubit/accounts_cubit.dart';
import 'package:xstock/modules/settings/cubit/accounts_state.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/modules/settings/widgets/account_tile.dart';
import 'package:xstock/ui/widgets/loading_indicator.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';
import 'package:xstock/utils/utils.dart';

class SwitchAccountDialog extends StatefulWidget {
  const SwitchAccountDialog({super.key});

  @override
  State<SwitchAccountDialog> createState() => _SwitchAccountDialogState();
}

class _SwitchAccountDialogState extends State<SwitchAccountDialog> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  List<AccountTitleModel> accounts = [];
  StreamConsumer<List<AccountTitleModel>> streamConsumer =
      StreamController.broadcast();
  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsCubit(),
      child: Dialog(
          backgroundColor: AppColors.fieldColor,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.fieldColor)),
          child: StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  DisplayUtils.showErrorToast(
                      context, snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularLoadingIndicator(),
                  );
                }
                accounts.clear();
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  if (a['user_id'] ==
                      userAccountRepository.getUserFromDb().user_id) {
                    accounts.add(AccountTitleModel(
                        id: a['user_id'],
                        name: a['branch_name'],
                        email: a['email'],
                        isSelected:
                            userAccountRepository.getUserFromDb().email ==
                                    a['email']
                                ? true
                                : false));
                  }
                }).toList();
                context
                    .read<AccountsCubit>()
                    .initialList(accounts);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Switch Account",
                        style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
                      SizedBox(
                        height: 16,
                      ),
                      BlocBuilder<AccountsCubit, AccountsState>(
                        builder: (context, state) {
                          return ListView.builder(
                              itemCount: state.accounts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return OnClick(
                                  onTap: () {
                                    context
                                        .read<AccountsCubit>()
                                        .updateAccountSelection(
                                        state.accounts[index].email);
                                  },
                                  child: AccountTile(
                                    model: state.accounts[index],
                                    backgroundColor: state.accounts[index].isSelected
                                        ? Color(0xff00D8FA)
                                        : Colors.black,
                                    titleColor: state.accounts[index].isSelected
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                );
                              });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: PrimaryButton(
                            onPressed: () {
                              NavRouter.pop(context);
                            },
                            title: 'Cancel',
                            height: 50,
                            borderRadius: 10,
                            backgroundColor: Colors.black,
                            borderColor: Colors.black,
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: PrimaryButton(
                              onPressed: ()async {
                                var user = context.read<AccountsCubit>().state.accounts
                                    .firstWhere((element) => element.isSelected);
                                var userModel = UserModel(
                                    branch_name: user.name,
                                    email: user.email,
                                    user_id: user.id);
                                ToastLoader.show();
                                await userAccountRepository.saveUserInDb(userModel).then((value){
                                  ToastLoader.remove();
                                  DisplayUtils.showToast(context, 'User switched successfully');
                                  NavRouter.pop(context);
                                });
                              },
                              title: 'Okay',
                              height: 50,
                              borderRadius: 10,
                              backgroundColor: context.colorScheme.secondary,
                              borderColor: context.colorScheme.secondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
