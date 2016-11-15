package org.kccc.d01_helloworld;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private TextView tvHelloWorld;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvHelloWorld = (TextView)findViewById(R.id.hello_world);
    }

    public void changeText(View view) {
        tvHelloWorld.setText("안녕 세상아");
        Toast.makeText(this, "안녕 세상아", Toast.LENGTH_SHORT).show();
    }


}
