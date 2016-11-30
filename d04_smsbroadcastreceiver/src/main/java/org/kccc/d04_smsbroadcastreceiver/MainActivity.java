package org.kccc.d04_smsbroadcastreceiver;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    private TextView tvSms;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvSms = (TextView)findViewById(R.id.sms);
    }

    protected void onResume() {
        super.onResume();

        processSmsData(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        intent.putExtra("first_received", true);
        setIntent(intent);
    }

    private void processSmsData(Intent intent) {
        ArrayList<String> smsData = intent.getStringArrayListExtra("sms");

        if (smsData == null) {
            return;
        }

        boolean firstReceived = intent.getBooleanExtra("first_received", false);
        intent.putExtra("first_received", false);

        String whereFrom= firstReceived ? "Activity reuse\n\n" : "Activity created\n\n";

        tvSms.setText(whereFrom + smsData.get(0));
    }

}
