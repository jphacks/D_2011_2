import 'dart:convert';

import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/agenda.dart';
import 'sharePage.dart';
import '../supportingFile/apiManager.dart';

class CreateMeetingPage extends StatefulWidget {
  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  String meetingTitle = "";
  DateTime meetingDate = DateTime.now();
  bool beforeHost = false;
  bool waitingRoom = true;

  // Keyboard Focus Node
  var _titleFocusNode = FocusNode();
  var _timeFocusNode = FocusNode();

  List<Agenda> agendas = [];

  bool isLoading = false;

  get formattedDate {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(meetingDate);
    return formatted;
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _titleFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _timeFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  void _openModalBottomSheet(
      {@required Size size, @required bool edit, int index = 0}) {
    var _titleController = TextEditingController();
    var _timeController = TextEditingController();

    if (edit) {
      _titleController.text = agendas[index].title;
      _timeController.text = agendas[index].min.toString();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return KeyboardActions(
              config: _buildConfig(context),
              child: Container(
                color: Color(0xFF737373),
                height: isKeyboardVisible
                    ? 350 + MediaQuery.of(context).viewInsets.bottom
                    : 350,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "議題の" + (edit ? "編集" : "追加"),
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
                                        controller: _titleController,
                                        focusNode: _titleFocusNode,
                                        textAlign: TextAlign.end,
                                        decoration: InputDecoration(
                                            hintText: "ディスカッション"),
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
                                        controller: _timeController,
                                        focusNode: _timeFocusNode,
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
                                    onPressed: () {
                                      try {
                                        final min = int.parse(
                                            _timeController.value.text);
                                        final title =
                                            _titleController.value.text;
                                        if (title != "" && min > 0) {
                                          final agenda =
                                              Agenda(title: title, min: min);
                                          setState(() {
                                            if (edit) {
                                              agendas[index] = agenda;
                                            } else {
                                              agendas.add(agenda);
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      } catch (exception) {
                                        print(exception);
                                      }
                                    },
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
                            height: isKeyboardVisible
                                ? MediaQuery.of(context).viewInsets.bottom + 50
                                : 0,
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
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
              onPressed: meetingTitle == "" && agendas.length == 0
                  ? null
                  : () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.SCALE,
                        title: '確認',
                        desc: 'ミーティングを作成してよろしいですか？',
                        btnOkOnPress: () async {
                          setState(() {
                            isLoading = true;
                          });
                          int duration = 0;
                          for (var i = 0; i < agendas.length; i++) {
                            duration += agendas[i].min;
                          }
                          final result = await FlutterZoomSdk.createMeeting(
                            title: meetingTitle,
                            date: meetingDate,
                            beforeHost: beforeHost,
                            waitingRoom: waitingRoom,
                            duration: duration,
                          );
                          if (result != null) {
                            print(result.id);
                            print(result.password);
                            final unixTime =
                                meetingDate.toUtc().millisecondsSinceEpoch ~/
                                    1000;
                            final params = CreateMeetingParams(
                              title: meetingTitle,
                              startTime: unixTime,
                              zoomId: result.id,
                              pass: result.password,
                              agendas: agendas,
                            );
                            final response =
                                await ApiManager.createZoomMeeting(params);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SharePage(
                                  title: meetingTitle,
                                  date: formattedDate.toString(),
                                  imageUrl: ApiManager.baseUrl +
                                      "/api/meeting/${response.id}/ogp.png",
                                  url: response.url,
                                ),
                              ),
                            );
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.SCALE,
                              headerAnimationLoop: false,
                              title: 'エラー',
                              desc: 'ミーティングの作成に失敗しました。時間を置いてもう一度お試しください。',
                              btnOkOnPress: () {},
                            )..show();
                          }
                        },
                        btnCancelOnPress: () {},
                      )..show();
                    },
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
                          onChanged: (val) {
                            setState(() {
                              meetingTitle = val;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1),
              GestureDetector(
                onTap: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    onConfirm: (date) {
                      setState(() {
                        meetingDate = date;
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.jp,
                  );
                },
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
                          formattedDate.toString(),
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
                          _openModalBottomSheet(size: size, edit: false);
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
                child: agendas.length == 0
                    ? Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            _openModalBottomSheet(size: size, edit: false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/add.png',
                                    height: size.width * 0.3,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "議題を追加してみましょう！",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.2,
                            child: Card(
                              child: ListTile(
                                title: Text(agendas[index].title),
                                trailing: Text("${agendas[index].min}分"),
                                onTap: () {
                                  _openModalBottomSheet(
                                    size: size,
                                    edit: true,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: '削除',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  setState(() {
                                    agendas.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        itemCount: agendas.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
