package org.kccc.d02_linearlayouttest;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private TextView tvNumA, tvNumB;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvNumA = (TextView) findViewById(R.id.textview_a);
        tvNumB = (TextView) findViewById(R.id.textview_b);
    }

    public void onButtonClicked(View view) {
        switch (view.getId()) {
            case R.id.button_0:
                tvNumA.setText("0");
                tvNumB.setText("0");
                break;

            case R.id.button_1:
                tvNumA.setText("1");
                tvNumB.setText("1");
                break;

            case R.id.button_2:
                tvNumA.setText("2");
                tvNumB.setText("2");
                break;

            default:
                break;
        }
    }
}