package org.kccc.d10_fastground;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        findViewById(R.id.activity_splash).postDelayed(() -> {
            startActivity(new Intent(this, LoginActivity.class));
            finish();
        }, 1000);
    }
}
