import 'package:flutter/material.dart';
import 'package:keyboard_utils/widgets.dart';

class CreateMeetingPage extends StatefulWidget {
  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  bool beforeHost = false;
  bool waitingRoom = true;
  bool isKeyBoardShown = false;

  void _openModalBottomSheet(Size size) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return KeyboardAware(
          builder: (context, keyboardConfig) {
            return Container(
              color: Color(0xFF737373),
              height: keyboardConfig.isKeyboardOpen
                  ? 350 + keyboardConfig.keyboardHeight
                  : 350,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "議題の追加",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text("議題"),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      decoration:
                                          InputDecoration(hintText: "ディスカッション"),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text("時間"),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      decoration:
                                          InputDecoration(hintText: "30"),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("分"),
                                ],
                              ),
                              SizedBox(height: 50),
                              SizedBox(
                                width: size.width - 60,
                                height: 50,
                                child: FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    "登録",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: keyboardConfig.isKeyboardOpen
                              ? keyboardConfig.keyboardHeight + 50
                              : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "ミーティングを作成",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text("Done"),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("ミーティング情報"),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("タイトル"),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11),
                          hintText: "定例会議",
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 1),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                width: size.width,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("開始時間"),
                      Text(
                        "2020/11/14 19:00",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 1),
            Container(
              height: 50,
              width: size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ホストより前の入室を許可する"),
                    Switch(
                        value: beforeHost,
                        onChanged: (val) {
                          setState(() {
                            beforeHost = val;
                          });
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1),
            Container(
              height: 50,
              width: size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("待機室を有効にする"),
                    Switch(
                        value: waitingRoom,
                        onChanged: (val) {
                          setState(() {
                            waitingRoom = val;
                          });
                        }),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("アジェンダ"),
                    GestureDetector(
                      onTap: () {
                        _openModalBottomSheet(size);
                      },
                      child: Container(
                        height: 25,
                        width: 30,
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("議題"),
                      trailing: Text("30分"),
                    ),
                  );
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}