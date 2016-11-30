package org.kccc.d05_cameratest;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.File;
import java.util.List;

/**
 * Fast campus 안드로이드 앱 프로젝트 CAMP
 * Basic for Android (by mindwing)
 * 예제 - Camera Test
 */
public class MainActivity extends AppCompatActivity {

    public static final int ACTION_CAPTURE = 0x2501;
    private File captureFilePath = new File(Environment.getExternalStoragePublicDirectory(
            Environment.DIRECTORY_PICTURES), "d05_cameratest.jpg");

    private ImageView ivImage;
    private TextView tvExif;

    // Can only use lower 8 bits for requestCode
    private static final int REQUEST_CODE_EXTERNAL_STORAGE = 251;
    private static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    ////////////////////////////////////////////
    ///// Activity Life Cycle 관련
    ////////////////////////////////////////////
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        ivImage = (ImageView) findViewById(R.id.captured_image);
        tvExif = (TextView) findViewById(R.id.exif);

        requestStoragePermission(this);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode != ACTION_CAPTURE || resultCode != RESULT_OK) {
            return;
        }

        int permission = ActivityCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission == PackageManager.PERMISSION_GRANTED) {
//            PhotoUtils.ensurePortraitPhoto(captureFilePath);
            setCaptureImage();
            viewExifInfo();
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    public void requestStoragePermission(Activity activity) {
        int permission = ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    activity,
                    PERMISSIONS_STORAGE,
                    REQUEST_CODE_EXTERNAL_STORAGE
            );
        } else {
            setCaptureImage();
            viewExifInfo();
        }
    }

    ////////////////////////////////////////////
    ///// 카메라 기능 관련
    ////////////////////////////////////////////
    public void captureCamera(View view) {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
//        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(captureFilePath));
        Uri photoURI = FileProvider.getUriForFile(this,
                "org.kccc.d05_cameratest.fileprovider",
                captureFilePath);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
        intent.putExtra(MediaStore.EXTRA_SCREEN_ORIENTATION,
                ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        checkAdditionalPermission(intent, photoURI);

        startActivityForResult(intent, ACTION_CAPTURE);
    }

    private void checkAdditionalPermission(Intent intent, Uri photoURI) {
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.KITKAT) {
            List<ResolveInfo> resInfoList = getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
            for (ResolveInfo resolveInfo : resInfoList) {
                String packageName = resolveInfo.activityInfo.packageName;
                grantUriPermission(packageName, photoURI, Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
            }
        }
    }

    private void viewExifInfo() {
        String origPhotoPath = captureFilePath.getAbsolutePath();

        BitmapFactory.Options origOptions = PhotoUtils.decodeBounds(origPhotoPath);
        ExifInterface exif = PhotoUtils.getExifInfo(origPhotoPath);

        if (exif == null) {
            tvExif.setText("(Unknown Error)");

            return;
        }

        PhotoUtils.PhotoOrientation exifOrientation = PhotoUtils.getExifOrientation(exif);

        String exifStr = origOptions.outWidth + " x " + origOptions.outHeight + ", " + exifOrientation;

        Log.d("tvExif", exifStr);

        tvExif.setText(exifStr);
    }

    private void setCaptureImage() {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inSampleSize = 8;
        Bitmap captureBitmap = BitmapFactory.decodeFile(captureFilePath.getAbsolutePath(), options);
        ivImage.setImageBitmap(captureBitmap);
    }
}
