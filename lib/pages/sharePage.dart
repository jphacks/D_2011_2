import 'package:flutter/material.dart';
import '../widget/customButton.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;
  final String url;

  SharePage({
    @required this.title,
    @required this.date,
    @required this.imageUrl,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Image.network(imageUrl),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: customButton(
                        title: "共有",
                        onPressed: () async {
                          final RenderBox box = context.findRenderObject();
                          await Share.share(
                            "$title at $date\n$url",
                            subject: "Generated with Aika",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: customButton(
                        title: "トップに戻る",
                        onPressed: () {
                          int count = 0;
                          Navigator.popUntil(context, (_) => count++ >= 2);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
