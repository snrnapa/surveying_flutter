import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({
    Key? key,
    required this.eleList,
  }) : super(key: key);
  final List<String> eleList;

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
              readOnly: true,
              // controller: _pointControllers[index]);
              initialValue: eleList[index]);
        },
      ),
    );
  }
}
