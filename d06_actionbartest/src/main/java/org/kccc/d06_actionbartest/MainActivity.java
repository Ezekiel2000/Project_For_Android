package org.kccc.d06_actionbartest;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        android.app.ActionBar ab1 = getActionBar();
        android.support.v7.app.ActionBar ab2 = getSupportActionBar();

        findViewById(R.id.activity_main).setOnClickListener(v -> {
            Intent intent = new Intent(getApplicationContext(), SubActivity.class);
            startActivity(intent);
        });

        android.support.v7.app.ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle("메인 Activity 입니다.");
    }
}
