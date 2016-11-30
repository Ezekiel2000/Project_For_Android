package org.kccc.d07_postrecyclerviewtest;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void startThread(View view) {
        new Thread(() -> view.post(
                () -> Toast.makeText(
                        this, "토스트", Toast.LENGTH_SHORT).show()
                )
        ).start();
    }
}
