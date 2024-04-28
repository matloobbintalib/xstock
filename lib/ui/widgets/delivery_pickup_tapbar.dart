import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class DeliveryPickupTapBar extends StatefulWidget {
  const DeliveryPickupTapBar({super.key});

  @override
  State<DeliveryPickupTapBar> createState() => _DeliveryPickupTapBarState();
}

class _DeliveryPickupTapBarState extends State<DeliveryPickupTapBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.grey3,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(
          2,
              (index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              height: 50,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:
                selectedIndex == index ? AppColors.black : AppColors.grey3,
              ),
              child: Center(
                child: Text(
                  index == 0 ? 'Delivery' : 'Pickup',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: selectedIndex == index
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}