package org.kccc.prayer111;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ImageButton;

public class MainActivity extends AppCompatActivity {

    ImageButton today_btn = (ImageButton) findViewById(R.id.imageButton);
    ImageButton month_btn = (ImageButton) findViewById(R.id.imageButton2);
    ImageButton daytoday_btn = (ImageButton) findViewById(R.id.imageButton3);
    ImageButton payers_btn = (ImageButton) findViewById(R.id.imageButton4);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



    }
}
