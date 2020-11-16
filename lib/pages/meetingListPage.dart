import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:share/share.dart';
import '../models/meeting.dart';

class MeetingListPage extends StatelessWidget {
  final List<Meeting> meetings;

  MeetingListPage(this.meetings);

  String formatDate(DateTime date) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(date);
    return formatted;
  }

  void _openModalBottomSheet({
    @required BuildContext context,
    @required int index,
    @required Size size,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          height: 300,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      meetings[index].title,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width - 60,
                            height: 50,
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                final RenderBox box =
                                    context.findRenderObject();
                                await Share.share(
                                  "${meetings[index].title} at ${meetings[index].date}\n${meetings[index].url}",
                                  subject: "Generated with Aika",
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) & box.size,
                                );
                              },
                              child: Text(
                                "共有",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: size.width - 60,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "ミーティングの開始",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ミーティング一覧",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: meetings.length == 0
            ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/agenda_illust.png',
                          height: size.width * 0.4,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "ミーティングを作成しましょう！",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(meetings[index].title),
                      trailing: Text(formatDate(meetings[index].date)),
                      onTap: () {
                        _openModalBottomSheet(
                          context: context,
                          index: index,
                          size: size,
                        );
                      },
                    ),
                  );
                },
                itemCount: meetings.length,
              ),
      ),
    );
  }
}
