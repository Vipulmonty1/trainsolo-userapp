import 'package:flutter/material.dart';

class ChooseReason extends StatefulWidget {
  ChooseReasonPage createState() => ChooseReasonPage();
}

final List dummyData = List.generate(10000, (index) => '$index');

class ChooseReasonPage extends State<ChooseReason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: 300,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dummyData.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return GridTile(
                child: Container(
                    color: Colors.blue[200],
                    alignment: Alignment.center,
                    child: Text(dummyData[index])));
          },
        ),
      ),
    );
  }
}
