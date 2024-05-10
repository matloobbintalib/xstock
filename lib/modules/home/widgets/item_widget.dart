import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

class ItemWidget extends StatelessWidget {
  final int index;

  const ItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: index == 0
              ? Color(0xFF9ADAB5)
              : index == 1
                  ? Color(0xFFDDB8E3)
                  : index == 2
                      ? Color(0xFF9BCCDB)
                      : Color(0xFF00D8FA)),
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 12),
            child: Row(
              children: [
                Expanded(child: Text('Items',style: context.textTheme.headlineSmall?.copyWith(color: Colors.black,fontSize: 16),)),
                SvgPicture.asset("assets/images/svg/ic_item.svg")
              ],
            ),
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/images/svg/ic_minus.svg")),
              Expanded(child: Text('07',style: context.textTheme.headlineLarge?.copyWith(color: Colors.black,fontSize: 32),textAlign: TextAlign.center,)),
              IconButton(onPressed: (){}, icon: SvgPicture.asset("assets/images/svg/ic_plus.svg")),
            ],
          )
        ],
      ),
    );
  }
}
