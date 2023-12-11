import 'package:flutter/material.dart';

class MenuCardTemplate extends StatelessWidget {
  const MenuCardTemplate({
    Key? key,
    required this.imagePath,
    required this.mainTitle,
    required this.explain,
  }) : super(key: key);
  final String imagePath;
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
          // 画像
          SizedBox(
              width: double.infinity,
              height: 128,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    )),
              )),
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
