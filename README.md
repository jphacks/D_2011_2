# D_2011_2

[ReadMe](https://github.com/jphacks/D_2011)

## 実装方法
### Cocoapodsのインストール
ターミナルでプロジェクトディレクトリにて`pod install`を実行してください。
### Zoom SDKのインストール
Zoom SDKの容量が大きく、Githubの制限容量を超過したため`git clone`をしたのちにZoom SDKをインストールしてください。
[こちら](https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/getting-started/install-sdk)からZoom SDKをダウンロードして、`MobileRTCResources.bundle`と`MobileRTC.framework`と`MobileRTCScreenShare.framework`をインポートしてください。
### Zoom APIキーの登録
SupportingFile/に`keys.plist`を作成し、`cliantKey`と`cliantSecret`を作成してください。
