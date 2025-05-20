package org.volumio.spotify_auth

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.PackageManager.NameNotFoundException
import com.spotify.sdk.android.auth.AuthorizationClient
import com.spotify.sdk.android.auth.AuthorizationRequest
import com.spotify.sdk.android.auth.AuthorizationResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import org.volumio.spotify_auth.AuthenticateReply
import org.volumio.spotify_auth.AuthenticateRequest

class SpotifyAuthPlugin : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener,
    SpotifyAuthApi {
    private var applicationContext: Context? = null
    private var applicationActivity: Activity? = null
    private var pendingAuthResult: ((Result<AuthenticateReply>) -> Unit)? = null

    companion object {
        const val REQUEST_CODE_AUTH = 420
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.applicationContext = binding.applicationContext

        SpotifyAuthApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = null

        SpotifyAuthApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        applicationActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        applicationActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        applicationActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        applicationActivity = null
    }

    override fun canAuthenticateUsingSpotifyApp(): Boolean {
        if (applicationContext == null) {
            throw IllegalStateException("Plugin not attached to a context.")
        }

        val pm: PackageManager = applicationContext!!.packageManager
        try {
            pm.getPackageInfo("com.spotify.music", 0)
            return true
        } catch (_: NameNotFoundException) {
            return false
        }
    }

    override fun authenticate(
        request: AuthenticateRequest,
        callback: (Result<AuthenticateReply>) -> Unit
    ) {
        if (pendingAuthResult != null) {
            callback(Result.failure(IllegalStateException("Already authenticating")))
            return
        }

        pendingAuthResult = callback
        AuthorizationClient.openLoginActivity(
            applicationActivity,
            REQUEST_CODE_AUTH,
            AuthorizationRequest.Builder(
                request.clientId,
                AuthorizationResponse.Type.CODE,
                request.redirectUri
            ).setScopes(request.scopes.toTypedArray()).build()
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE_AUTH) {
            return false
        }

        val response = AuthorizationClient.getResponse(resultCode, data)
        val callback = pendingAuthResult
        pendingAuthResult = null

        if (callback == null) {
            return false
        }

        when (response.type) {
            AuthorizationResponse.Type.CODE -> {
                callback(Result.success(AuthenticateReply(response.code, null)))
            }

            AuthorizationResponse.Type.ERROR -> {
                callback(Result.failure(Exception(response.error)))
            }

            else -> {
                callback(Result.failure(Exception("Unknown response type")))
            }
        }

        return true
    }
}
