import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final String name;          // e.g., "أحمد"
  final String assetPath;     // e.g., "assets/avatars/boy1.png"
  final bool selected;
  final VoidCallback onTap;

  const ChildAvatar({
    super.key,
    required this.name,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.width*0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // avatar circle with selection ring
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: const [
                BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, 2)),
              ],
              border: Border.all(
                color: selected ? const Color(0xFFFF8A00) : Colors.transparent,
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: size.width*0.08,
              backgroundColor: const Color(0xFFEAFBF1), // soft bg like mock
              backgroundImage: AssetImage(assetPath),
            ),
          ),
           SizedBox(height: size.height*0.002),
          Text(
            name,
            textDirection: TextDirection.rtl,
            style:  TextStyle(
              fontSize: size.width*0.035,
              fontWeight: FontWeight.w700,
              color: Color(0xFF273238),
            ),
          ),
        ],
      ),
    );
  }
}
