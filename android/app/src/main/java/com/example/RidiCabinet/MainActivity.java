package com.example.RidiCabinet;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import androidx.core.content.ContextCompat;

import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;
import java.util.function.LongFunction;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.view.FlutterView;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import vn.momo.momo_partner.AppMoMoLib;
import vn.momo.momo_partner.MoMoParameterNamePayment;

public class MainActivity extends FlutterActivity {
    public static final String CHANNEL = "flutter.native/AndroidPlatform";
    public static final String MyPREFERENCES = "MyPrefs" ;
    public SharedPreferences sharedpreferences;
    public SharedPreferences.Editor editor;
    public static FlutterView flutterView;

    MethodChannel.Result resultTemp;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        flutterView = getFlutterView();
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("addUserInfo")){
                            result.success("addUserInfo");
                            UserDetail.id = call.argument("id");
                            UserDetail.email = call.argument("username");
                            UserDetail.username = call.argument("email");
                            sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
                            editor = sharedpreferences.edit();
                            editor.putString("id", call.argument("id"));
                            editor.putString("username", call.argument("username"));
                            editor.putString("email", call.argument("email"));
                            editor.commit();
                        }

                        if (call.method.equals("deleteUserInfo")){
                            result.success("deleteUserInfo");
                            Socket hehe = ForegroundService.mSocket;
                            if (hehe.connected())
                            {
                                JSONObject input = new JSONObject();
                                try {
                                    input.put("user_id", UserDetail.id);
                                    input.put("socket_id", hehe.id());
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                hehe.emit("exit_app", input);
                            }
                            UserDetail.id = "";
                            UserDetail.email = "";
                            UserDetail.username = "";
                            sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
                            editor = sharedpreferences.edit();
                            editor.clear();
                            editor.commit();
                        }

                        if (call.method.equals("getMoMoToken")) {
                            Integer amount = call.argument("amount");
                            String no = call.argument("box_no");
                            String station_location = call.argument("station_location");
                            String station_address = call.argument("station_address");
                            String station_no = call.argument("station_no");
                            String periodTemp = call.argument("period");
                            String period = null;

                            if (periodTemp.equals("1")){
                                period = "1 hour";
                            }else if (periodTemp.equals("2")){
                                period = "1 day";
                            }else if (periodTemp.equals("3")){
                                period = "1 month";
                            }

                            String description = "BOX NO: " + no + "\n" +
                                    "TIME USING: " + period + "\n" +
                                    "STATION ADDRESS: " + station_address + "\n" +
                                    "STATION LOCATION: " + station_location + "\n" +
                                    "STATION NO: " + station_no;

                            resultTemp = result;
                            requestPayment(amount, description);
                        }

                        if (call.method.equals("startSocket")) {
                            UserDetail.state = true;
                            result.success("startSocket");
                            startService();
                        }
                    }});
    }

    public void startService() {
        Intent serviceIntent = new Intent(this, ForegroundService.class);
        //serviceIntent.putExtra("inputExtra", "Foreground Service Example in Android");
        ContextCompat.startForegroundService(this, serviceIntent);
    }

    private void requestPayment(Integer amount, String description) {
        String merchantName =  "DHD";
        String merchantCode = "MOMOTOAE20200418";

        AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT);
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT);
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN);

        Map<String, Object> eventValue = new HashMap<>();
        //client Required
        eventValue.put(MoMoParameterNamePayment.MERCHANT_NAME, merchantName);
        eventValue.put(MoMoParameterNamePayment.MERCHANT_CODE, merchantCode);
        eventValue.put(MoMoParameterNamePayment.AMOUNT, amount);
        eventValue.put(MoMoParameterNamePayment.DESCRIPTION, description);

        //Request momo app
        AppMoMoLib.getInstance().requestMoMoCallBack(this, eventValue);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == -1) {
            JSONObject input = new JSONObject();
            try {
                input.put("status", data.getIntExtra("status", -1));
                input.put("message", data.getStringExtra("message"));
                input.put("data", data.getStringExtra("data"));
                input.put("phonenumber", data.getStringExtra("phonenumber"));
            } catch (JSONException e) {
                e.printStackTrace();
            }
            resultTemp.success(String.valueOf(input));
        }
    }

    @Override
    public void onDestroy()
    {
        UserDetail.state = false;
        sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
        editor = sharedpreferences.edit();

        String id = sharedpreferences.getString("id", "");
        Socket hehe = ForegroundService.mSocket;
        if (hehe.connected() && id.length() != 0)
        {
            JSONObject input = new JSONObject();
            try {
                input.put("user_id", id);
                input.put("socket_id", hehe.id());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            hehe.emit("exit_app", input);
        }
        super.onDestroy();
    }
}