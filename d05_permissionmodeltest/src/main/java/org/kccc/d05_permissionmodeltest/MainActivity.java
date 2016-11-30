package org.kccc.d05_permissionmodeltest;

import android.Manifest;
import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private TextView tvStorage, tvContacts;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvStorage = (TextView) findViewById(R.id.storage);
        tvContacts = (TextView) findViewById(R.id.contacts);

        showSign();

        Button btRequestPermission = (Button) findViewById(R.id.permission);
        btRequestPermission.setOnClickListener(v -> processPermissions());
    }

    private static final int REQUEST_CODE_EXTERNAL_STORAGE_CONTACTS = 251;

    private static String[] PERMISSION_NEEDED = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_CONTACTS
    };

    public void  processPermissions() {
        showSign();

        if (!hasStorageGranted() || !hasContactsGranted()) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(
                    this, Manifest.permission.READ_EXTERNAL_STORAGE) ||
                    ActivityCompat.shouldShowRequestPermissionRationale(
                            this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
                Toast.makeText(this, "설정에서 '저장소와 '주소록 읽기'권한을 모두 승인해주세요", Toast.LENGTH_SHORT).show();
            }

            ActivityCompat.requestPermissions(
                    this,
                    PERMISSION_NEEDED,
                    REQUEST_CODE_EXTERNAL_STORAGE_CONTACTS
            );
        }
    }

    private boolean hasStorageGranted() {
        int permissionStorage = ActivityCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE);

        return permissionStorage == PackageManager.PERMISSION_GRANTED;
    }

    private boolean hasContactsGranted() {
        int permissionContacts = ActivityCompat.checkSelfPermission(this,
                Manifest.permission.READ_CONTACTS);

        return permissionContacts == PackageManager.PERMISSION_GRANTED;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_EXTERNAL_STORAGE_CONTACTS:
                showSign();

                if (grantResults.length == 3 && grantResults[0] + grantResults[1] + grantResults[2]
                        == PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this,
                            "'저장소 읽기'와 '주소록 읽기'가 모두 승인되었습니다", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this,
                            "'저장소 읽기'와 '주소록 읽기'요청을 모두 혹은 일부 거부하셨습니다", Toast.LENGTH_SHORT).show();
                }
                break;

            default:
                break;
        }
    }

    private void showSign() {
        if (hasStorageGranted()) {
            tvStorage.setBackgroundColor(0xFF00FF00);
            tvStorage.setText("O");
        }

        if (hasContactsGranted()) {
            tvContacts.setBackgroundColor(0xFF00FF00);
            tvContacts.setText("0");
        }
    }
}
