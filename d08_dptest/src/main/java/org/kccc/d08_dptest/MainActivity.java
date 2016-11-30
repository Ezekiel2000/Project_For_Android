package org.kccc.d08_dptest;

import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Display;
import android.view.WindowManager;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setModel();
        setTitle();
    }

    public void setModel() {
        TextView tvModel = (TextView) findViewById(R.id.model);
        tvModel.setText(Build.MODEL + ", API Level " + Build.VERSION.SDK_INT);
    }

    public void setTitle() {
        Display display = ((WindowManager) getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
        Point deviceSize = new Point();
        display.getSize(deviceSize);

        float scale = getResources().getDisplayMetrics().density;
        int dpi = getResources().getDisplayMetrics().densityDpi;
//        int width = getResources().getDisplayMetrics().widthPixels;
//        int height = getResources().getDisplayMetrics().heightPixels;

        String dpiStr;
        if (dpi <= 120) {
            dpiStr = "ldpi";
        } else if (dpi <= 160) {
            dpiStr = "mdpi";
        } else if (dpi <= 240) {
            dpiStr = "hdpi";
        } else if (dpi <= 320) {
            dpiStr = "xhdpi";
        } else if (dpi <= 480) {
            dpiStr = "xxhdpi";
        } else if (dpi <= 640) {
            dpiStr = "xxxhdpi";
        } else {
            dpiStr = "(UNKNOWN)";
        }

        setTitle(String.format("[%sx%s] %s(%sx, %sDPI)",
                deviceSize.x, deviceSize.y, dpiStr, scale, dpi));

    }
}

