package com.example.ecommadmin
import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.FlutterPlugin
//import io.flutter.plugins.GeneratedPluginRegistrant

/*
FlutterActivity = This method is called after the given FlutterEngine has been attached to the owning FragmentActivity
FlutterEngine = the container through which Dart code can be run in an Android application
 */
class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ///GeneratedPluginRegistrant.registerWith(this);
    }

    override fun configureFlutterEngine(binding: FlutterEngine) {
        super.configureFlutterEngine(binding) //missing this
        //val plugin = AlarmScheduler()
        //plugin.onAttachedToEngine(binding)
    }
}