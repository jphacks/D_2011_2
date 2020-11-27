# aika(クライアントサイド)
最新の情報や詳しい内容は、以下の[aika(サーバーサイド)](https://github.com/jphacks/D_2011)に集約しています。  
Zoomの環境構築のみクライアントサイド限定の情報となります。  
[aikaの全てが分かるReadMeはこちら](https://github.com/jphacks/D_2011)
## 製品概要
本アプリはZoomでのオンラインミーティングをより円滑に進めるための支援サービスです。
オンラインミーティングではつい雑談などに逸れてしまい、ミーティングが長引いてしまうことが多々あります。そんなオンラインミーティングの進行を制御してくれるサービスがこの「aika」です。
aikeでは事前に設定したアジェンダに沿って、今話すべき議題の提示、時間が過ぎた際に一度全員の音声をミュートにするなどしてミーティングの進行を支援します。
Ruby介してzoom用のバーチャルカメラを作成したところが本サービスの最大のアピールポイントです。
### 製品紹介動画
[製品紹介動画](https://youtu.be/IIrvYkngzpM)  
[iPhoneデモ動画](https://youtu.be/HdyPTUS1vMw)
### 背景(製品開発のきっかけ、課題等）
Zoomでの会議は何故か雑談で長くなってしまう。この課題に対して、Zoomでの会議の有能な議長を行ってくれるアプリをつくりました。事前に作成したアジェンダに沿って会議が進められます。議題と残り時間が、仮想カメラ上に表示され現在話し合う内容を確認することができます。勿論、アプリから時間延長などのすべての操作が可能です。また、会議終了後は自動的に議事録が作成され会議の手間を省くことができます。

## 環境構築
### Zoom APIキーの登録
#### iOS
ios/Runner/にある`keys_sample.plist`を参考に`keys.plist`作成し、`cliantKey`と`cliantSecret`を作成してください。
#### Android
android/app/src/main/kotlin/jp/tommy/aika_flutterにある`Credentials_Sample.kt`を参考に`Credentials.kt`作成し、`cliantKey`と`cliantSecret`を作成してください。

## 開発技術
### 開発言語
- Flutter
- Swift
- Kotlin

### 活用した技術
#### SDK
- ZoomSDK

#### 外部ライブラリ (Flutter純正ライブラリを除く)
- modal_progress_hud
- IntroductionScreen
- Flutter Keyboard Visibility
- Keyboard Actions
- flutter_slidable
- Flutter Datetime Picker
- awesome_dialog

#### デバイス
- iPhone
- iPad
- Android
