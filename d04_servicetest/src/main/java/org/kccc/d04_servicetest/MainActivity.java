package org.kccc.d04_servicetest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    Intent serviceIntent;
    TextView tvCount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        tvCount = (TextView)findViewById(R.id.count);

        serviceIntent = new Intent(this, CounterService.class);
    }

    @Override
    protected void onResume() {
        super.onResume();
        startCountService();
    }

    @Override
    protected void onPause() {
        super.onPause();
        stopCountService();
    }

    private void startCountService() {
        LocalBroadcastManager.getInstance(this).
                registerReceiver(countReceiver,
                new IntentFilter(CounterService.EVENT_COUNT_NAME));
        startService(serviceIntent);
    }

    private void stopCountService() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(countReceiver);
        Intent intent = new Intent(this, CounterService.class);
        stopService(intent);
    }

    private BroadcastReceiver countReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int count = intent.getIntExtra(CounterService.EVENT_COUNT, -1);
            tvCount.setText(Integer.toString(count));
        }
    };
}
