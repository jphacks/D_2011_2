# D_2011_2

[ReadMe](https://github.com/jphacks/D_2011)
# aika
## 製品概要
本アプリはZoomでのオンラインミーティングをより円滑に進めるための支援サービスです。
オンラインミーティングではつい雑談などに逸れてしまい、ミーティングが長引いてしまうことが多々あります。そんなオンラインミーティングの進行を制御してくれるサービスがこの「aika」です。
aikeでは事前に設定したアジェンダに沿って、今話すべき議題の提示、時間が過ぎた際に一度全員の音声をミュートにするなどしてミーティングの進行を支援します。
Ruby介してzoom用のバーチャルカメラを作成したところが本サービスの最大のアピールポイントです。
### 製品紹介動画
[https://youtu.be/jOA8AHZRrZE](https://youtu.be/jOA8AHZRrZE)
### 背景(製品開発のきっかけ、課題等）
Zoomでの会議は何故か雑談で長くなってしまう。この課題に対して、Zoomでの会議の有能な議長を行ってくれるアプリをつくりました。事前に作成したアジェンダに沿って会議が進められます。議題と残り時間が、仮想カメラ上に表示され現在話し合う内容を確認することができます。勿論、アプリから時間延長などのすべての操作が可能です。また、会議終了後は自動的に議事録が作成され会議の手間を省くことができます。

## 環境構築
### Zoom SDKのインストール
Zoom SDKの容量が大きく、Githubの制限容量を超過したため`git clone`をしたのちにZoom SDKをインストールしてください。
[こちら](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/getting-started/install-sdk)からZoom SDKをダウンロードして、`MobileRTCResources.bundle`と`MobileRTC.framework`と`MobileRTCScreenShare.framework`をインポートしてください。
### Zoom APIキーの登録
SupportingFile/に`keys.plist`を作成し、`cliantKey`と`cliantSecret`を作成してください。

## 開発技術

### 活用した技術
#### SDK
* ZoomSDK

#### フレームワーク・ライブラリ・モジュール (Swift Package Manager)
* Eureka
* PKHUD
* RealmSwift
* paper-onboarding
* Alamofire

#### デバイス
* iPhone
* iPad
