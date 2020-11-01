package com.example.battery_plugin.activity;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.provider.Settings;

import androidx.annotation.NonNull;
import com.google.firebase.messaging.FirebaseMessaging;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  static final String CHANNEL_ID = "1010";

  private static final String CHANNEL = "initial";
  private static final String EVENTS = "eventWhileAppIsRunning";
  private String startString;
  private BroadcastReceiver linksReceiver;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    createNotificationChannel();
    FirebaseMessaging.getInstance().getToken().addOnSuccessListener(this, token -> {
     System.out.println("registrationToken =" + token);
    });

    Intent intent = getIntent();
    Uri data = intent.getData();
    if (data != null)
        System.out.println(data.toString());

    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
           if (call.method.equals("initialLink")) {
                if (startString != null) {
                  result.success(startString);
                }
              }
            }
    );

    new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), EVENTS).setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object args, final EventChannel.EventSink events) {
                linksReceiver = createChangeReceiver(events);
              }

              @Override
              public void onCancel(Object args) {
                linksReceiver = null;
              }
            }
    );

    if (data != null) {
      startString = data.toString();
      System.out.println(startString);
      if(linksReceiver != null) {
        linksReceiver.onReceive(this.getApplicationContext(), intent);
      }
    }}

    @Override
    public void onNewIntent(Intent intent){
      super.onNewIntent(intent);
      if(intent.getAction() == android.content.Intent.ACTION_VIEW && linksReceiver != null) {
        linksReceiver.onReceive(this.getApplicationContext(), intent);
      }
    }

    private BroadcastReceiver createChangeReceiver(final EventChannel.EventSink events) {
      return new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
          // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW

          String dataString = intent.getDataString();

          if (dataString == null) {
            events.error("UNAVAILABLE", "Link unavailable", null);
          } else {
            events.success(dataString);
          }
        }
      };
    }



  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
            "battery_plugin/channel"
    )
    .setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("showNotificationCenter")){
            showNotificationCenter();
          }
          else if (call.method.equals("subscribeToTopic")){
            FirebaseMessaging.getInstance().subscribeToTopic(call.argument("topic"));
            System.out.println("subscribed to : " + call.argument("topic"));
          }
          else if (call.method.equals("_unsubscribeFromTopic")){
            FirebaseMessaging.getInstance().unsubscribeFromTopic(call.argument("topic"));
            System.out.println("unsubscribed from : " + call.argument("topic"));
          }
          else {
            result.notImplemented();
          }
        }
      );
  }

  private void showNotificationCenter() {
    Intent intent = new Intent();
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
      intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
      intent.putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName());
    } else if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
      intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
      intent.putExtra("app_package", getPackageName());
      intent.putExtra("app_uid", getApplicationInfo().uid);
    } else {
      intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
      intent.addCategory(Intent.CATEGORY_DEFAULT);
      intent.setData(Uri.parse("package:" + getPackageName()));
    }
    startActivity(intent);
  }

  private void createNotificationChannel() {
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
      int importance = NotificationManager.IMPORTANCE_DEFAULT;
      NotificationChannel channel = new NotificationChannel(
        CHANNEL_ID,
        "name",
        importance
      );
      channel.setDescription("description");

      NotificationManager notificationManager = getSystemService(
        NotificationManager.class
      );
      notificationManager.createNotificationChannel(channel);
    }
  }




}
