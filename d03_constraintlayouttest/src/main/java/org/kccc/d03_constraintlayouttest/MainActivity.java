package org.kccc.d03_constraintlayouttest;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private TextView tvLabel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvLabel = (TextView)findViewById(R.id.tvLabel);

        findViewById(R.id.btHello).setOnClickListener(v -> tvLabel.setText("Hello~"));
        findViewById(R.id.btWorld).setOnClickListener(v -> tvLabel.setText("World~"));

    }
}
