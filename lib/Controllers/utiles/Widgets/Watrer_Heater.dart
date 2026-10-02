import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WaterHeater extends StatefulWidget {
  const WaterHeater({required this.color, required   this.textColor,required this.name,required this.onTap, super.key});
  final String name;
  final Color textColor;
  final Color color;
  final Function  onTap;
  @override
  State<WaterHeater> createState() => _WaterHeaterState();
}

class _WaterHeaterState extends State<WaterHeater> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Container(
      // width: screenWidth * 0.06,
      // height: screenHeight * 0.01,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black87, offset: Offset(2, 3), blurRadius: 4)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         Text(
              widget.name,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),


             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.online_prediction_outlined)),

                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                  activeTrackColor: Colors.yellow,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceDim,
                ),
              ],
            ),

        ],
      ),
    );
  }
}
