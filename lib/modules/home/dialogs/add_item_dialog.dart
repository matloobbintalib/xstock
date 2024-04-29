import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/ui/widgets/remember_me_widget.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController inputCountController = new TextEditingController();
  TextEditingController minimumAlertCountController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  int _selectedTabIndex = 0;
  final _tabs = [
    Tab(text: 'Add Quality'),
    Tab(text: 'Reduce Quality'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: AppColors.lightGreen),
              padding: EdgeInsets.only(left: 20, right: 16) +
                  EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    '03',
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: Colors.black),
                  ),
                  Expanded(
                      child: Text(
                    'Item Name',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  )),
                  SvgPicture.asset("assets/images/svg/ic_edit_item.svg")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
              child: Column(
                children: [
                  Text(
                    '4/15/2024  05:00 PM',
                    style:
                        context.textTheme.headlineSmall?.copyWith(fontSize: 12),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: kToolbarHeight - 8.0,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 0,
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: context.colorScheme.primary),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      unselectedLabelColor: Colors.white,
                      tabs: _tabs,
                      onTap: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  InputField(
                      controller: inputCountController,
                      label: 'Input Count',
                      verticalPadding: 18,
                      borderRadius: 20,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: SvgPicture.asset(
                            _selectedTabIndex == 0?"assets/images/svg/ic_add_item.svg":'assets/images/svg/ic_minus.svg'),
                      ),
                      textInputAction: TextInputAction.done),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Minimum Stock Alert",
                        style: context.textTheme.bodyMedium,
                      )),
                      SvgPicture.asset("assets/images/svg/ic_take_picture.svg")
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  InputField(
                      controller: minimumAlertCountController,
                      label: 'i-e : 01',
                      verticalPadding: 18,
                      borderRadius: 20,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done),
                  SizedBox(
                    height: 14,
                  ),
                  RememberMeWidget(
                    title: "Enable Expiry Date Alerts(Optional)",
                    titleColor: Colors.white,
                    checkBoxSize: 18,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InputField(
                      controller: dateController,
                      label: 'Select Date',
                      verticalPadding: 18,
                      readOnly: true,
                      borderRadius: 20,
                      borderColor: Colors.black,
                      fillColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Disclaimer! Expiry Date Alerts give notifications 2 day before expiry.",
                    style: context.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                  SizedBox(
                    height: 14,
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
                          onPressed: () {},
                          title: 'Confirm',
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
            )
          ],
        ),
      ),
    );
  }
}
