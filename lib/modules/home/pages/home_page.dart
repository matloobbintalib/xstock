import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/dialogs/item_detail_dialog.dart';
import 'package:xstock/modules/home/dialogs/new_group_dialog.dart';
import 'package:xstock/modules/home/models/group_model.dart';
import 'package:xstock/modules/home/widgets/group_widget.dart';
import 'package:xstock/modules/settings/pages/settings_page.dart';
import 'package:xstock/ui/input/input_field.dart';
import 'package:xstock/ui/widgets/on_click.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  List<GroupModel> groups = [
    GroupModel(
      id: 1,
      title: "Default Group",
      isExpandable: true
    ),
    GroupModel(
      id: 2,
      title: "Group Name",
      isExpandable: true
    ),
  ];
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
                      showDialog(context: (context), builder: (context){
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
              fontWeight: FontWeight.w400 ,
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
                child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return OnClick(onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ItemDetailDialog();
                            });
                      },
                      child: GroupWidget(groupModel: groups[index], onClick: () {
                        groups.forEach((element) {
                          if (element.id == groups[index].id) {
                            element.isExpandable = !element.isExpandable;
                          }
                        });
                        setState(() {});
                      },));
                    })),
          ],
        ),
      ),
    );
  }
}
