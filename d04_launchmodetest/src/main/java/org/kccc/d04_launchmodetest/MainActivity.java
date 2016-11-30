package org.kccc.d04_launchmodetest;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;
import android.widget.Toast;

public abstract class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Intent intentStandard = new Intent(this, StandardActivity.class);
        Intent intentSingleTop = new Intent(this, SingleTopActivity.class);
        Intent intentSingleTask = new Intent(this, SingleTaskActivity.class);
        Intent intentSingleInstance = new Intent(this, SingleInstanceActivity.class);

        TextView tvActivityLaunchMode = (TextView)findViewById(R.id.tvActivityLaunchMode);
        tvActivityLaunchMode.setText(getClass().getSimpleName());

        findViewById(R.id.btStandard).setOnClickListener(v -> startActivity(intentStandard));
        findViewById(R.id.btSingleTop).setOnClickListener(v -> startActivity(intentSingleTop));
        findViewById(R.id.btSingleTask).setOnClickListener(v -> startActivity(intentSingleTask));
        findViewById(R.id.btSingleInstance).setOnClickListener(v -> startActivity(intentSingleInstance));

    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        Toast.makeText(this, "onNewIntent() called!!!", Toast.LENGTH_SHORT).show();
    }

    public static class SingleInstanceActivity extends MainActivity {

    }

    public static class SingleTaskActivity extends MainActivity {

    }

    public static class SingleTopActivity extends MainActivity {

    }

    public static class StandardActivity extends MainActivity {

    }
}
