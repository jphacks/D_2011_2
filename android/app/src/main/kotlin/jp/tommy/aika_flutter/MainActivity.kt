package jp.tommy.aika_flutter

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import us.zoom.sdk.*
import us.zoom.sdk.ZoomError.ZOOM_ERROR_SUCCESS
import java.util.*

class MainActivity: FlutterActivity(), ZoomSDKInitializeListener, ZoomSDKAuthenticationListener, PreMeetingServiceListener {
    private val CHANNEL = "flutter_zoom_sdk"
    private val TAG  = "ZOOM_SDK_ANDROID"
    private var flutterResult: MethodChannel.Result? = null
    private var sharedSDK = ZoomSDK.getInstance()
    private var preMeetingService = ZoomSDK.getInstance().preMeetingService

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
                "userEmail" -> {
                    result.success(sharedSDK.accountService?.accountEmail)
                }
                "createMtg" -> {
                    val title = call.argument<String>("title")
                    val date = call.argument<Int>("date")
                    val beforeHost = call.argument<Boolean>("beforeHost")
                    val waitingRoom = call.argument<Boolean>("waitingRoom")
                    val duration = call.argument<Int>("duration")
                    val email = sharedSDK.accountService.accountEmail
                    if (title != null &&
                            date != null &&
                            beforeHost != null &&
                            waitingRoom != null &&
                            duration != null) {
                        createMeeting(title, date, beforeHost, waitingRoom, duration, email)
                    } else {
                        result.notImplemented()
                    }
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

    private fun createMeeting(title: String,
                              timeInUnix: Int,
                              beforeHost: Boolean,
                              waitingRoom: Boolean,
                              duration: Int,
                              email: String) {
        preMeetingService = sharedSDK.preMeetingService
        preMeetingService.addListener(this)
        val meeting = preMeetingService.createScheduleMeetingItem()
        meeting.meetingTopic = title
        meeting.startTime = timeInUnix.toLong() * 1000
        meeting.durationInMinutes = duration
        meeting.timeZoneId = TimeZone.getDefault().id
        meeting.canJoinBeforeHost = beforeHost
        meeting.isEnableWaitingRoom = waitingRoom
        meeting.scheduleForHostEmail = email

        val error = preMeetingService.scheduleMeeting(meeting)
        Log.i(TAG, "$error")
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

    override fun onScheduleMeeting(p0: Int, p1: Long) {
        val meeting = preMeetingService.getMeetingItemByUniqueId(p1)
        flutterResult?.success("${meeting.meetingNumber},${meeting.password}")
    }

    override fun onListMeeting(p0: Int, p1: MutableList<Long>?) {}
    override fun onUpdateMeeting(p0: Int, p1: Long) {}
    override fun onDeleteMeeting(p0: Int) {}
}

