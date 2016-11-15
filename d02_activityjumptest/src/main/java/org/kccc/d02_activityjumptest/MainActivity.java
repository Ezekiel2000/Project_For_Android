package org.kccc.d02_activityjumptest;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    public static final String TAG = MainActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Log.d(TAG, "LifeCycle: onCreate()");
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "LifeCycle: onStart()");
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d(TAG, "LifeCycle: onResume()");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.d(TAG, "LifeCycle: onPause()");
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "LifeCycle: onStop()");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "LifeCycle: onDestroy()");
    }

    public void jump(View view) {
        Intent jumpToSecondActivity = new Intent(this, SecondActivity.class);

        jumpToSecondActivity.putExtra("title", "Second Activity");

        jumpToSecondActivity.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        jumpToSecondActivity.addFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK);

        startActivity(jumpToSecondActivity);

//        finish();
    }
}
