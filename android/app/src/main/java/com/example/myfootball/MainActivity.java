package com.example.myfootball;

import android.os.Bundle;

import com.google.firebase.FirebaseApp;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    FirebaseApp.initializeApp(this);
  }
}
