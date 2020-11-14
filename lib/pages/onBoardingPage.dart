import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "aikaへようこそ",
            body: "aikaはzoomでの会議をより円滑に進める\nお手伝いをします。",
            image: _buildImage('bannar-light'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "まずはミーティングを\n作成しましょう",
            body: "アプリから簡単にZoomミーティングを\n作成することができます",
            image: _buildImage('meeting'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "会議の議題を登録しましょう",
            body: "事前に登録された議題に沿って\naikaが会議を円滑に進めるお手伝いをします。",
            image: _buildImage('agenda_illust'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "会議をシェアしましょう",
            body: "aikaから作成された会議は議題と一緒に\nシェアすることができます。",
            image: _buildImage('share'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text('スキップ'),
        next: Icon(Icons.arrow_forward),
        done: Text('さぁはじめよう', style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
