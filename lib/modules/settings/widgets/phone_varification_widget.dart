import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/common/repo/session_repository.dart';
import 'package:xstock/ui/widgets/custom_switch.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class PhoneVerificationWidget extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const PhoneVerificationWidget({super.key, required this.title, required this.onTap});

  @override
  State<PhoneVerificationWidget> createState() => _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  bool isSelected = false;
  SessionRepository sessionRepository = sl<SessionRepository>();
  @override
  void initState() {
    super.initState();
    bool isEnable = sessionRepository.isEnableItemVibration();
    isSelected = isEnable;
  }
  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(color: AppColors.fieldColor,borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: context.textTheme.bodyMedium,
              ),
            ),
            CustomSwitch(onChanged: (value) async{
              setState(() {
                isSelected = value;
              });
              await sessionRepository.setItemVibration(isSelected);
            }, value: isSelected)
          ],
        ),
      ),
    );
  }
}

