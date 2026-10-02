import 'package:flutter/material.dart';
class SkillBadges extends StatelessWidget {
  const SkillBadges({
    super.key,
    required this.current,           // Arabic label, e.g. 'مبتدئ'
  });

  final String current;

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.005, vertical: size.height*0.005),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(16),


      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _chip(label: 'مبتدئ', emoji: '🌱', color: Colors.orange,   active: current.trim() == 'مبتدئ'/*||current.trim() == 'خبير'||current.trim() == 'ماهر'*/,size:size),
          SizedBox(width: size.width*0.010),
          _chip(label: 'خبير', emoji: '⭐', color: Colors.orange, active: current.trim() == 'خبير'/*|| current.trim() == 'ماهر'*/,size: size),
          SizedBox(width: size.width*0.010),
          _chip(label: 'ماهر',  emoji: '🏅', color: Colors.orange,  active: current.trim() == 'ماهر',size: size),
          SizedBox(width: size.width*0.008),
          _chip(label: 'متميز',  emoji: '🏆', color: Colors.orange,  active: current.trim() == 'متميز',size: size),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required String emoji,
    required Color color,
    required bool active,
    required Size size,
  }) {
    return Opacity(
      opacity: active ? 1.0 : 0.35,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: size.width*0.020, vertical: size.height*0.005),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.12) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: active ? color : Colors.grey.shade400, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700, color: active ? color : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Text(emoji, style:  TextStyle(fontSize: size.width*0.04)),

          ],
        ),
      ),
    );
  }
}

