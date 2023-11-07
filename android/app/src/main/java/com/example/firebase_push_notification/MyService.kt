package com.example.firebase_push_notification

import android.app.Service
import android.content.Intent
import android.os.IBinder
import androidx.annotation.Nullable
import android.util.Log

class MyService : Service()
{
    private val TAG = "MyService"
    @Nullable
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        println("=======>> From background service <<========")
        Log.d(TAG,"=======>> From background service <<========")
        return START_STICKY

    }

}