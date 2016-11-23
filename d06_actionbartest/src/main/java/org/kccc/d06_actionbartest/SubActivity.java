package org.kccc.d06_actionbartest;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.TextView;

public class SubActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sub);

        TextView tvCount = (TextView) findViewById(R.id.count);
        Intent intent = getIntent();
        int count = intent.getIntExtra("count", 0);

        tvCount.setText(Integer.toString(count));

        findViewById(R.id.activity_sub).setOnClickListener(v -> {
            Intent intent1 = getIntent();
            int count1 = intent1.getIntExtra("count", 0);

            Intent subIntent = new Intent(getApplicationContext(), SubActivity.class);
            subIntent.putExtra("count", ++count1);

            startActivity(subIntent);
        });

        android.support.v7.app.ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle("서브 Activity 입니다.");
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }
}
