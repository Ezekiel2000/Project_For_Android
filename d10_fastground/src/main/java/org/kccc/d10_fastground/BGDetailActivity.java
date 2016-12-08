package org.kccc.d10_fastground;

import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;

public class BGDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bgdetail);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }

    public void onBGSelect(View view) {
        Snackbar.make(view, "Select 버튼", Snackbar.LENGTH_SHORT).show();
    }

    public void onBGFavorite(View view) {
        Snackbar.make(view, "Like 버튼", Snackbar.LENGTH_SHORT).show();
    }
}
