package jp.tommy.aika_flutter

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import us.zoom.sdk.*
import us.zoom.sdk.ZoomError.ZOOM_ERROR_SUCCESS

class MainActivity: FlutterActivity(), ZoomSDKInitializeListener, ZoomSDKAuthenticationListener {
    private val CHANNEL = "flutter_zoom_sdk"
    private val TAG  = "ZOOM_SDK_ANDROID"
    private var flutterResult: MethodChannel.Result? = null
    private var sharedSDK: ZoomSDK = ZoomSDK.getInstance()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        authZoomSDK()
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
                    sharedSDK.loginWithZoom(email, pass)
                }
                "logout" -> {
                    sharedSDK.logoutZoom()
                }
                "userName" -> {
                    result.success(sharedSDK.accountService?.accountName)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun authZoomSDK() {
        sharedSDK = ZoomSDK.getInstance()
        val initparams = ZoomSDKInitParams()
        initparams.appKey = Credentials.SDK_KEY
        initparams.appSecret = Credentials.SDK_SECRET
        initparams.domain=  "zoom.us"
        sharedSDK.initialize(context, this, initparams)
        sharedSDK.addAuthenticationListener(this)
    }

    override fun onZoomSDKInitializeResult(p0: Int, p1: Int) {
        if (p0 == ZOOM_ERROR_SUCCESS) {
            Log.i(TAG,"SDK auth succeeded")
        } else {
            Log.i(TAG,"SDK authentication failed, error code: $p0")
        }
    }
    override fun onZoomAuthIdentityExpired() {}

    override fun onZoomSDKLoginResult(p0: Long) {
        flutterResult?.success(p0.toInt() == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS)
    }

    override fun onZoomSDKLogoutResult(p0: Long) {}
    override fun onZoomIdentityExpired() {}
}

