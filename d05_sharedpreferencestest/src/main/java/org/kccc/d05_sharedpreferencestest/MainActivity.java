package org.kccc.d05_sharedpreferencestest;

// SharedPreferences 적용 전
//public class MainActivity extends AppCompatActivity {
//
//    private static int count;
//    private TextView tvCount;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
//
//        tvCount = (TextView)findViewById(R.id.count);
//
//    }
//
//    @Override
//    protected void onResume() {
//        super.onResume();
//
//        tvCount.setText(Integer.toString(count++));
//    }
//}

// SharedPreferences 적용 후
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import static android.content.Context.MODE_PRIVATE;
import static org.kccc.d05_sharedpreferencestest.R.id.count;

public class MainActivity extends AppCompatActivity {

    private static final String COUNT_NUMBER = "count_number";
    private static final String PREF_NAME = "count";
    private TextView tvCount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvCount = (TextView)findViewById(count);

    }

    @Override
    protected void onResume() {
        super.onResume();

        SharedPreferences prefs = getSharedPreferences(PREF_NAME, MODE_PRIVATE);

        int count = prefs.getInt(COUNT_NUMBER, 0);

        tvCount.setText(Integer.toString(count));

        SharedPreferences.Editor editor = prefs.edit();
        editor.putInt(COUNT_NUMBER, ++count);
        editor.apply();
    }
}