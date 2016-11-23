package org.kccc.d06_snackbar;

import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private Snackbar snackbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View rootView = findViewById(R.id.activity_main);
        rootView.setOnClickListener(view -> snackbar.show());

        snackbar = Snackbar.make(rootView, "스낵바입니다", Snackbar.LENGTH_INDEFINITE)
                .setAction("버튼", view -> Toast.makeText(getBaseContext(),
                        "토스트를 띄웠습니다", Toast.LENGTH_LONG).show());

    }
}
