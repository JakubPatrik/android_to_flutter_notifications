package com.example.battery_plugin.activity;

import android.app.Activity;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.service.notification.StatusBarNotification;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.example.battery_plugin.R;

import java.util.ArrayList;

class Funcs extends Activity {

    Intent resultIntent;
    PendingIntent pendingIntent;
    TaskStackBuilder tsb;

    private ArrayList<String> readNotification() {
        ArrayList<String> l = new ArrayList();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
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
                "battery_plugin/channel"
        )
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle(title)
                .setContentText(description)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        resultIntent = new Intent(this, MainActivity.class);
        tsb = TaskStackBuilder.create(this);
        tsb.addParentStack(getApplicationContext().getClass());

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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
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

/*
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
          }
          else if (call.method.equals("readNotification")) {
            ArrayList<String> res = readNotification();
            if (res != null) {
              result.success(res);
            } else {
              result.error("EMPTY", "Cannot fetch active notifications", null);
            }
          }
*/