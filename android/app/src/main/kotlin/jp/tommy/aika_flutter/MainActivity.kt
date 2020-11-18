package jp.tommy.aika_flutter

import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import us.zoom.sdk.*
import us.zoom.sdk.ZoomError.ZOOM_ERROR_SUCCESS

class MainActivity: FlutterActivity(), ZoomSDKInitializeListener, ZoomSDKAuthenticationListener {
    private val CHANNEL = "flutter_zoom_sdk"
    private var flutterResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        authZoomSDK()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            flutterResult = result
            when (call.method) {
                "isLoggedIn" -> {
                    result.success(ZoomSDK.getInstance().isLoggedIn)
                }
                "login" -> {
                    val email = call.argument<String>("email")
                    val pass = call.argument<String>("password")
                    val remember = call.argument<Boolean>("remember")
                    returnTrue()
//                    ZoomSDK.getInstance().addAuthenticationListener(this)
//                    ZoomSDK.getInstance().loginWithZoom(email, pass)
                }
                "userName" -> {
                    result.success("Tommy")
//                    result.success(ZoomSDK.getInstance().accountService.accountName)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun authZoomSDK() {
        val initParams = ZoomSDKInitParams().apply {
            appKey = Credentials.SDK_KEY
            appSecret = Credentials.SDK_SECRET
            domain = "zoom.us"
        }
        ZoomSDK.getInstance().initialize(this, this, initParams)
        ZoomSDK.getInstance().addAuthenticationListener(this)
    }

    fun returnTrue() {
        flutterResult?.success(true)
    }

    override fun onZoomSDKInitializeResult(p0: Int, p1: Int) {
        if (p0 == ZOOM_ERROR_SUCCESS) {
            println("SDK auth succeeded")
        } else {
            println("SDK authentication failed, error code: $p0")
        }
    }
    override fun onZoomAuthIdentityExpired() {}

    override fun onZoomSDKLoginResult(p0: Long) {
        flutterResult?.success(p0.toInt() == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS)
    }

    override fun onZoomSDKLogoutResult(p0: Long) {}
    override fun onZoomIdentityExpired() {}
}

