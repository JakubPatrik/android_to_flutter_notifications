package com.example.battery_plugin.activity;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.provider.Settings;
import android.service.notification.StatusBarNotification;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.example.battery_plugin.R;
import com.google.firebase.messaging.FirebaseMessaging;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
//
import java.util.ArrayList;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "battery_plugin/channel";
  static final String CHANNEL_ID = "1010";

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    createNotificationChannel();
    FirebaseMessaging.getInstance().getToken().addOnSuccessListener(this, token -> {
     System.out.println("registrationToken =" + token);
    });

  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      CHANNEL
    )
    .setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("getBatteryLevel")) {
            int batteryLevel = getBatteryLevel();

            if (batteryLevel != -1) {
              result.success(batteryLevel);
            } else {
              result.error("UNAVAILABLE", "Battery level not available.", null);
            }
          } else if (call.method.equals("showNotification")) {
            showNotification(
              call.argument("title"),
              call.argument("description"),
              call.argument("id")
            );
          } else if (call.method.equals("readNotification")) {
            ArrayList<String> res = readNotification();
            if (res != null) {
              result.success(res);
            } else {
              result.error("EMPTY", "Cannot fetch active notifications", null);
            }
          }
          else if (call.method.equals("showNotificationCenter")){
            showNotificationCenter();
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

  Intent resultIntent;
  PendingIntent pendingIntent;
  TaskStackBuilder tsb;

  private ArrayList<String> readNotification() {
    ArrayList<String> l = new ArrayList();
    if (VERSION.SDK_INT >= VERSION_CODES.M) {
      StatusBarNotification[] sbn = getSystemService(NotificationManager.class)
        .getActiveNotifications()
        .clone();
      for (StatusBarNotification n : sbn) {
        l.add(n.getNotification().extras.getString("android.title"));
      }
      return l;
    }
    return null;
  }

  private void showNotification(String title, String description, String id) {
    NotificationCompat.Builder builder = new NotificationCompat.Builder(
      this,
      CHANNEL_ID
    )
      .setSmallIcon(R.drawable.ic_launcher)
      .setContentTitle(title)
      .setContentText(description)
      .setPriority(NotificationCompat.PRIORITY_DEFAULT);

    resultIntent = new Intent(this, MainActivity.class);
    tsb = TaskStackBuilder.create(this);
    tsb.addParentStack(MainActivity.this);

    tsb.addNextIntent(resultIntent);
    pendingIntent = tsb.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);

    builder.setContentIntent(pendingIntent);

    NotificationManagerCompat notificationManager = NotificationManagerCompat.from(
      this
    );

    // notificationId is a unique int for each notification that you must define
    notificationManager.notify(Integer.parseInt(id), builder.build());
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(
        BATTERY_SERVICE
      );
      batteryLevel =
        batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext())
      .registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel =
        (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
        intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }
}
