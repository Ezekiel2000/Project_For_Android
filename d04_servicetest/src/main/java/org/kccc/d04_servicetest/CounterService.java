package org.kccc.d04_servicetest;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.widget.Toast;

public class CounterService extends Service implements Runnable {
    public static final String EVENT_COUNT_NAME = "count_event";
    public static final String EVENT_COUNT = "count";
    private Thread loop;

    public CounterService() {

    }

    @Override
    public void onCreate() {
        Toast.makeText(this, "CounterService.onCreate()", Toast.LENGTH_SHORT).show();

        (loop = new Thread(this)).start();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Toast.makeText(this, "CounterService.onStartCommand()", Toast.LENGTH_SHORT).show();

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onDestroy() {
        Toast.makeText(this, "CounterService.onDestroy()", Toast.LENGTH_SHORT).show();

        loop.interrupt();
    }

    @Override
    public void run() {
        Intent countIntent = new Intent(EVENT_COUNT_NAME);
        int count = 0;

        try {
            while (true) {
                countIntent.putExtra(EVENT_COUNT, count++);
                LocalBroadcastManager.getInstance(this).sendBroadcast(countIntent);
                Thread.sleep(1000);
            }
        } catch (InterruptedException ie) {
            Log.d("MyService", "MyService interrupted");
        }
    }
}

