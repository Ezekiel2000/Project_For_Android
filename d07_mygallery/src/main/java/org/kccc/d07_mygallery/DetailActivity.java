package org.kccc.d07_mygallery;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class DetailActivity extends AppCompatActivity {

    public static final String PATH = "path";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        Intent intent = getIntent();
        String path = intent.getStringExtra(PATH);
        Bitmap bm = Utils.getBitmap(path, false);

        TextView tvPath = (TextView) findViewById(R.id.path);
        tvPath.setText(path);

        ImageView ivImage = (ImageView) findViewById(R.id.image);
        ivImage.setImageBitmap(bm);
    }
}
