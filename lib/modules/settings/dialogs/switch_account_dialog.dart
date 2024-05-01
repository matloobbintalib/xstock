import 'package:flutter/material.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/settings/models/account_title_model.dart';
import 'package:xstock/modules/settings/widgets/account_tile.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/utils.dart';

class SwitchAccountDialog extends StatefulWidget {
  const SwitchAccountDialog({super.key});

  @override
  State<SwitchAccountDialog> createState() => _SwitchAccountDialogState();
}

class _SwitchAccountDialogState extends State<SwitchAccountDialog> {
  List<AccountTitleModel> accounts = [
    AccountTitleModel(
        id: 1, name: "Abc", email: "abc@gmail.com", isSelected: true),
    AccountTitleModel(id: 2, name: "Def", email: "def@gmail.com"),
    AccountTitleModel(id: 3, name: "Ghi", email: "ghi@gmail.com"),
    AccountTitleModel(id: 4, name: "Jkl", email: "jkl@gmail.com"),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.fieldColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.fieldColor)),
      child: Container(
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
            ListView.builder(
                itemCount: accounts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return OnClick(
                    onTap: () {
                      accounts.forEach((element) {
                        if (element.id == accounts[index].id) {
                          element.isSelected = !element.isSelected;
                        } else {
                          element.isSelected = false;
                        }
                      });
                      setState(() {});
                    },
                    child: AccountTile(
                      model: accounts[index],
                      backgroundColor: accounts[index].isSelected
                          ? Color(0xff00D8FA)
                          : Colors.black,
                      titleColor: accounts[index].isSelected?Colors.black:Colors.white,
                    ),
                  );
                }),
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
      ),
    );
  }
}
