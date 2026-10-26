package com.manja.app

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/// Hands files opened with Manja (a shared .manja profile) to the app as a path in its cache.
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var pending: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "manja/opened_file").apply {
            setMethodCallHandler { call, result ->
                if (call.method == "take") {
                    result.success(pending)
                    pending = null
                } else {
                    result.notImplemented()
                }
            }
        }
        pending = copyOpened(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val path = copyOpened(intent) ?: return
        channel?.invokeMethod("opened", path)
    }

    private fun copyOpened(intent: Intent?): String? {
        val uri: Uri = when (intent?.action) {
            Intent.ACTION_VIEW -> intent.data
            Intent.ACTION_SEND -> @Suppress("DEPRECATION") intent.getParcelableExtra(Intent.EXTRA_STREAM)
            else -> null
        } ?: return null
        return try {
            val target = File(cacheDir, "opened.manja")
            contentResolver.openInputStream(uri)?.use { input ->
                target.outputStream().use { output -> input.copyTo(output) }
            } ?: return null
            target.path
        } catch (e: Exception) {
            null
        }
    }
}
