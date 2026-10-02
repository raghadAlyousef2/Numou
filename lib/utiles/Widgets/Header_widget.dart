import 'package:flutter/material.dart';

import '../Constant/strings.dart';


class header extends StatelessWidget {
  const header({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Container(
      margin: const EdgeInsets.all(20),
      width: screenWidth * 2.3,
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme
              .of(context)
              .primaryColor,
          boxShadow: const [
            BoxShadow(
                color: Colors.black87, offset: Offset(2, 3), blurRadius: 4)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 30),
                child: Text('Hi  , $ProfileName', style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                ),),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Text(DaviceName,style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
