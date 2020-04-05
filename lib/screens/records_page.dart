import 'package:datavendor/helpers/data_database_helper.dart';
import 'package:datavendor/models/data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
//  DatabaseHelper _databaseHelper = DatabaseHelper();
//  List<SentDataInfo> sentDataInfoList;
  final db = DataHelper();
  List<Data> datas = [];
  int count = 0;

  void setupList() async {
    var _datas = await db.fetchAll();
    print(_datas);

    setState(() {
      datas = _datas;
      count = _datas.length;
    });
  }

  delete(int id) async {
    await db.deleteRecord(id);
    setupList();
  }

  @override
  void initState() {
    super.initState();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
//    if (sentDataInfoList == null) {
//      sentDataInfoList = List<SentDataInfo>();
//      updateListView();
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${count.toString()} Records'),
      ),
      body: getSentDataListView(),
    );
  }

  ListView getSentDataListView() {
    return ListView.builder(
        itemCount: datas.length,
        itemBuilder: (BuildContext context, position) {
          return Card(
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: FittedBox(
                    child: Text('${datas[position].data_amount} MB'),
                  ),
                ),
              ),
              isThreeLine: true,
              title: Text('To: ${datas[position].phone_number} '),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Date: ${datas[position].date_sent}'),
                  Text('Time: ${datas[position].time_sent}')
                ],
              ),
              trailing: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trashAlt,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => delete(datas[position].id)),
            ),
          );
        });
  }
}
