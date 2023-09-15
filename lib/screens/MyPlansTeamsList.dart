import 'package:flutter/material.dart';
import '../model/ItemModel.dart';

class MyPlansTeamsList extends StatefulWidget {
  final String pagename;
  MyPlansTeamsList({@required this.pagename});
  MyPlansTeamsListPage createState() => MyPlansTeamsListPage();
}

class MyPlansTeamsListPage extends State<MyPlansTeamsList> {
  final List<ItemModel> _items = [];

  Widget buildPageView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                    // Widget which creates [ItemWidget] in scrollable list.
                    itemCount: _items.length, // Number of widget to be created.
                    itemBuilder: (context, itemIndex) =>
                        ItemWidget(_items[itemIndex], () {
                      _onItemTap(context, _items[itemIndex]);
                    }, () {
                      _shareItem(context, _items[itemIndex]);
                    }, () {
                      _save(context, _items[itemIndex]);
                    }),
                  )))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildPageView(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 237, 28, 36),
        label: Text("Create Team"),
        onPressed: () {},
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

_onItemTap(BuildContext context, ItemModel item) {
  print("this team screen index is " + item.title);
}

_shareItem(BuildContext context, ItemModel item) {
  print("this is on tap _shareItem and index is " + item.title);
}

_save(BuildContext context, ItemModel item) {
  print("this is on tap _save and index is " + item.title);
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.model, this.onItemTap, this._shareItem, this._save,
      {Key key})
      : super(key: key);

  final ItemModel model;
  final Function onItemTap;
  // ignore: unused_field
  final Function _shareItem;
  // ignore: unused_field
  final Function _save;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Enables taps for child and add ripple effect when child widget is long pressed.
      onTap: onItemTap,
      child: Container(
          height: 90,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Container(
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 237, 28, 36),
                              border: Border.all(
                                color: Color.fromARGB(255, 237, 28, 36),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                            child: Text(
                              model.title.substring(0, 2),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.title,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Text(model.description,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'HelveticaNeue',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )),
                    ],
                  )),
                ),
              )
            ],
          )),
    );
  }
}
