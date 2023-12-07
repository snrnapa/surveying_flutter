import 'package:flutter/material.dart';

class IHListContainer extends StatelessWidget {
  const IHListContainer({
    Key? key,
    required this.eleList,
  }) : super(key: key);
  final List<TextEditingController> eleList;

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
            enabled: false,
            controller: eleList[index],
            decoration:
                InputDecoration(filled: true, fillColor: Colors.black12),
          );
        },
      ),
    );
  }
}
