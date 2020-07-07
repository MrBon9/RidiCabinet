package com.example.RidiCabinet;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.Random;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import io.flutter.plugin.common.MethodChannel;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

import static xdroid.toaster.Toaster.toast;

public class ForegroundService extends Service {
    public static final String MyPREFERENCES = "MyPrefs";
    public SharedPreferences sharedpreferences;
    public SharedPreferences.Editor editor;
    public static Socket mSocket;

    @Override
    public void onCreate() {
        super.onCreate();
        try {
            mSocket = IO.socket(UserDetail.api);
            if (!mSocket.connected()) {
                Log.d("hello", "connect");
                mSocket.connect();
                mSocket.on("for_mobile", server_restart);
                mSocket.on("server", onRetrieData);
                mSocket.on("not_close", onRetrieData1);
                mSocket.on("socket_id", onRetrieData2);
                mSocket.on("blockUser", onRetrieData3);
                mSocket.on("authorize", onRetrieData4);
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Start background activities
        sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
        String id = sharedpreferences.getString("id", "");

        if (id.length() == 0) {
            Log.d("Account", "log out");
        } else {
            Log.d("Account", id);
            UserDetail.id = id;
            UserDetail.username = sharedpreferences.getString("username", "");
            UserDetail.email = sharedpreferences.getString("email", "");

            JSONObject input = new JSONObject();
            try {
                input.put("user_id", UserDetail.id);
                input.put("socket_id", mSocket.id());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            mSocket.emit("mobile_client", input);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String NOTIFICATION_CHANNEL_ID = "com.example.RidiCabinet";
            String channelName = "Background Service";
            NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName,
                    NotificationManager.IMPORTANCE_NONE);
            chan.setLightColor(Color.BLUE);
            chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            assert manager != null;
            manager.createNotificationChannel(chan);
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this,
                    NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
                    .setContentTitle("App is running in background").setPriority(NotificationManager.IMPORTANCE_NONE)
                    .setCategory(Notification.CATEGORY_SERVICE).build();
            startForeground(1, notification);
        }
        return START_NOT_STICKY;
    }

    // server confirms that station has been connected
    private Emitter.Listener server_restart = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];
            try {
                String name = obj.getString("message");
                if (name.equals("I see you")) {
                    mSocket.disconnect();
                    Thread.sleep(100);
                    mSocket.connect();
                }
                Log.d("Message", "server restart");
            } catch (JSONException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    };

    // server confirms that station has been connected
    private Emitter.Listener onRetrieData = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];
            try {
                String message = obj.getString("message");
                toast(message);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

    // not close box
    private Emitter.Listener onRetrieData1 = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];

            try {
                String message = "Your box no " + String.valueOf(obj.getString("box_no")) + " at station no "
                        + obj.getString("station_no") + " location " + obj.getString("station_location")
                        + " has not been closed yet!";

                if (obj.getString("user_id").equals(UserDetail.id)) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                        String CHANNEL_ID = "Basic activities";
                        NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID, "not_close",
                                NotificationManager.IMPORTANCE_LOW);
                        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 1, intent, 0);
                        @SuppressLint("WrongConstant")
                        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(),
                                CHANNEL_ID).setSmallIcon(R.drawable.ic_launcher_background).setContentTitle("Warning")
                                        .setContentText(message)
                                        .setStyle(new NotificationCompat.BigTextStyle().bigText(message))
                                        .setVisibility(Notification.VISIBILITY_PUBLIC)
                                        .setDefaults(Notification.DEFAULT_SOUND).setContentIntent(pendingIntent)
                                        // .addAction(android.R.drawable.sym_action_chat,"Title",pendingIntent)
                                        .setPriority(NotificationCompat.PRIORITY_DEFAULT);

                        NotificationManager notificationManager = (NotificationManager) getSystemService(
                                Context.NOTIFICATION_SERVICE);
                        notificationManager.createNotificationChannel(notificationChannel);
                        int random = new Random().nextInt((1000 - 2) + 1) + 2;
                        notificationManager.notify(random, builder.build());
                        Log.d("Notification no:", String.valueOf(random));
                    }
                    // toast(message);
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

    // server sends socket_id
    private Emitter.Listener onRetrieData2 = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];

            try {
                String socket_id = args[0].toString();
                if (UserDetail.state && UserDetail.id.length() != 0) {
                    JSONObject input = new JSONObject();
                    input.put("user_id", UserDetail.id);
                    input.put("socket_id", socket_id);
                    mSocket.emit("mobile_client", input);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

    // server blocks user
    private Emitter.Listener onRetrieData3 = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];
            String user_id = null;
            String active = null;

            try {
                user_id = obj.getString("user_id");
                active = obj.getString("active");
            } catch (JSONException e) {
                e.printStackTrace();
            }

            if (user_id.equals(UserDetail.id)) {
                Log.d("blockUser", obj.toString());
                String finalUser_id = user_id;
                String finalActive = active;
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        MethodChannel process = new MethodChannel(MainActivity.flutterView, MainActivity.CHANNEL);
                        JSONObject input = new JSONObject();
                        try {
                            input.put("user_id", finalUser_id);
                            input.put("active", finalActive);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        process.invokeMethod("blockUser", input.toString());
                    }
                });
            }
        }
    };

    // new authorize
    private Emitter.Listener onRetrieData4 = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject obj = (JSONObject) args[0];
            String authorize_id = null;

            try {
                authorize_id = obj.getString("authorize_id");
            } catch (JSONException e) {
                e.printStackTrace();
            }
            if (authorize_id.equals(UserDetail.id)) {
                String message = null;

                try {
                    JSONObject owner_id_field = new JSONObject(obj.getString("owner_id"));
                    JSONObject box_id_field = new JSONObject(obj.getString("box_id"));
                    JSONObject station_id_field = new JSONObject(obj.getString("station_id"));
                    message = "You has been authorized a box by " + owner_id_field.getString("email").toString() + ":"
                            + " box no " + box_id_field.getString("no").toString() + " at station location "
                            + station_id_field.getString("location").toString() + " - " + "no "
                            + station_id_field.getString("no").toString() + " in "
                            + station_id_field.getString("placename").toString();

                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                    String CHANNEL_ID = "Basic activities";
                    NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID, "authorize",
                            NotificationManager.IMPORTANCE_LOW);
                    PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 1, intent, 0);
                    @SuppressLint("WrongConstant")
                    NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(),
                            CHANNEL_ID).setSmallIcon(R.drawable.ic_launcher_background)
                                    .setContentTitle("Authorize feature").setContentText(message)
                                    .setStyle(new NotificationCompat.BigTextStyle().bigText(message))
                                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                                    .setDefaults(Notification.DEFAULT_SOUND).setContentIntent(pendingIntent)
                                    // .addAction(android.R.drawable.sym_action_chat,"Title",pendingIntent)
                                    .setPriority(NotificationCompat.PRIORITY_DEFAULT);

                    NotificationManager notificationManager = (NotificationManager) getSystemService(
                            Context.NOTIFICATION_SERVICE);
                    notificationManager.createNotificationChannel(notificationChannel);
                    int random = new Random().nextInt((1000 - 2) + 1) + 2;
                    notificationManager.notify(random, builder.build());
                    Log.d("Notification no:", String.valueOf(random));
                }
            }
        }
    };
}
