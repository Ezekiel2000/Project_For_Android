package org.kccc.d04_intentservicetest;

import android.app.IntentService;
import android.content.Intent;
import android.os.SystemClock;
import android.support.v4.content.LocalBroadcastManager;


public class RandomService extends IntentService {
    public static final String EVENT_RANDOM = "random";
    public static final String EVENT_RANDOM_NUMBER = "random_number";

    public RandomService() {
        super("RandomService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        int value = (int)(Math.random()*1000);

        Intent resultIntent = new Intent(EVENT_RANDOM);
        resultIntent.putExtra(EVENT_RANDOM_NUMBER, value);

        SystemClock.sleep(1000);

        LocalBroadcastManager.getInstance(this).sendBroadcast(resultIntent);
    }
}
