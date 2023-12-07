import 'package:flutter/material.dart';

class BSListContainer extends StatelessWidget {
  const BSListContainer({
    Key? key,
    required this.eleList,
    required this.bmCheckList,
  }) : super(key: key);
  final List<TextEditingController> eleList;
  final List<bool> bmCheckList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 600,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eleList.length,
        itemBuilder: (BuildContext context, int index) {
          return TextFormField(
            style: TextStyle(
              fontSize: 13,
            ),
            enabled: bmCheckList[index],
            controller: eleList[index],
            decoration: InputDecoration(
                filled: !bmCheckList[index], fillColor: Colors.black12),
          );
        },
      ),
    );
  }
}
