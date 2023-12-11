import 'package:flutter/material.dart';
import 'card_icon.dart';

class MenuCardTemplate extends StatelessWidget {
  const MenuCardTemplate({
    Key? key,
    required this.icon,
    required this.mainTitle,
    required this.explain,
  }) : super(key: key);
  final Widget icon;
  final String mainTitle;
  final String explain;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 128,
            child: Container(child: CardIcon(icon: icon)),
          ),
          // タイトル
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              mainTitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // 説明文
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              explain,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
