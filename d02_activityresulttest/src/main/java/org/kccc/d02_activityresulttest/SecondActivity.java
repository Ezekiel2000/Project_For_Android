package org.kccc.d02_activityresulttest;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

public class SecondActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second);

        setTitle("Second Activity");
    }

    public void returnResult(View view) {
        Intent resultIntent = new Intent();
        resultIntent.putExtra("result", "결과값 리턴!!");

        setResult(RESULT_OK, resultIntent);

        finish();
    }
}
