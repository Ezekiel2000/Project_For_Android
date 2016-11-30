package org.kccc.d04_intentservicetest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.widget.Button;
import android.widget.TextView;

/**
 * Created by Ezekiel on 2016. 11. 22..
 */

public class RandomActivity extends AppCompatActivity {

    private TextView tvNumber;
    private String name;
    private Intent randomIntent;

    public RandomActivity(String _name) {
        name = _name;
    }

    int getLayoutResourceld() {
        return getClass() == MainActivity1.class ? R.layout.activity_main1 :
                R.layout.activity_main2;
    }

    Class getAnotherActivity() {
        return getClass() == MainActivity1.class ? MainActivity2.class : MainActivity1.class;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getLayoutResourceld());

        setTitle(name);

        randomIntent = new Intent(this, RandomService.class);

        tvNumber = (TextView)findViewById(R.id.number);
        Button tvButton = (Button)findViewById(R.id.jump_activity);
        tvButton.setOnClickListener(v -> {
            Intent intent = new Intent(getBaseContext(),
                    getAnotherActivity());
            startActivity(intent);
            finish();
        });
    }

    @Override
    protected void onResume() {
        super.onResume();

        LocalBroadcastManager.getInstance(this).registerReceiver(
                messageReceiver,
                new IntentFilter(RandomService.EVENT_RANDOM));

        Intent intent = new Intent(this, RandomService.class);
        startService(intent);
    }

    private BroadcastReceiver messageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int message =
                    intent.getIntExtra(RandomService.EVENT_RANDOM_NUMBER, 0);
            tvNumber.setText(Integer.toString(message));

            startService(randomIntent);
        }
    };
}
