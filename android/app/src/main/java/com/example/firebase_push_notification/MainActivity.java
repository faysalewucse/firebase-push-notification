package com.example.firebase_push_notification;

import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String AUDIO_PLAY_CHANNEL = "rootX/playAudio";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), AUDIO_PLAY_CHANNEL).setMethodCallHandler((call, result) -> {
            if(call.method.equals("playAudio")){
                playAudio();
            }
            if(call.method.equals("stopAudio")){
                stopPlaying();
            }
        });

    }

    MediaPlayer player;
    void playAudio() {
        player = MediaPlayer.create(this, R.raw.preview);
        player.start();
    }

    void stopPlaying() {
        player.stop();
        player.release();
        player = new MediaPlayer();


    }



    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        Log.e("MainActivity", "===========================================");
        startService(new  Intent(this, MyService.class));
    }

}
