import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/config.dart';
import 'package:xstock/constants/app_colors.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/ui/widgets/appbar_widget.dart';
import 'package:xstock/ui/widgets/primary_button.dart';
import 'package:xstock/utils/utils.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
          child: Column(
            children: [
              AppbarWidget(
                title: 'Subscription',
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.fieldColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10, bottom: 18),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(.3),
                            spreadRadius: .1,
                            blurRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Free",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 36),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "7 Days Trial After",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/svg/ic_checkbox.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do qua",
                          style: context.textTheme.bodyMedium,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/svg/ic_checkbox.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Lorem ipsum dolor sit amet, consectetur.",
                          style: context.textTheme.bodyMedium,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(.3),
                            spreadRadius: .1,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        onPressed: () {
                          NavRouter.pushWithAnimation(context, HomePage(),
                              type: PageTransitionType.size,
                              hasAlignment: true);
                        },
                        fontWeight: FontWeight.w500,
                        title: "Get it now",
                        backgroundColor: context.colorScheme.secondary,
                        height: 60,
                        borderRadius: 28,
                        borderColor: context.colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.fieldColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10, bottom: 18),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(.3),
                            spreadRadius: .1,
                            blurRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "€ 5",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 36),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "monthly",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                            "assets/images/svg/ic_checkbox_green.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do qua",
                          style: context.textTheme.bodyMedium,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/svg/ic_checkbox.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Lorem ipsum dolor sit amet, consectetur.",
                          style: context.textTheme.bodyMedium,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(.3),
                            spreadRadius: .1,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        onPressed: () {
                          NavRouter.pushWithAnimation(context, HomePage(),
                              type: PageTransitionType.size,
                              hasAlignment: true);
                        },
                        fontWeight: FontWeight.w500,
                        title: "Get it now",
                        backgroundColor: context.colorScheme.secondary,
                        height: 60,
                        borderRadius: 28,
                        borderColor: context.colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
