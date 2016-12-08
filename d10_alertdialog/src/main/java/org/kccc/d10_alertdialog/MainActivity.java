package org.kccc.d10_alertdialog;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        findViewById(android.R.id.content).setOnClickListener(this::popupAlertDialog);
    }

    private void showSnackbar(View view, int which) {
        String msg = (which == DialogInterface.BUTTON_POSITIVE ?
        "OK를 선택했습니다." : "Cancel을 선택했습니다.");
        Snackbar.make(view, msg, Snackbar.LENGTH_SHORT).show();
    }

    private void popupAlertDialog(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Alert Dialog Test")
                .setMessage("Cancel / OK 를 눌러주세요.")
                .setPositiveButton("OK", (dialog, which) -> showSnackbar(view, which))
                .setNegativeButton("Cancel", (dialog, which) -> showSnackbar(view, which))
                .show();
    }
}
