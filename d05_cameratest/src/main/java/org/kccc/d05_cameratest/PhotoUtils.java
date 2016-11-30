package org.kccc.d05_cameratest;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Fast campus 안드로이드 앱 프로젝트 CAMP
 * Basic for Android (by mindwing)
 * 예제 - Camera Test
 */
public class PhotoUtils {
    private static final String TAG = PhotoUtils.class.getSimpleName();
    private static final int PHOTO_WIDTH = 1080;
    private static final int PHOTO_HEIGHT = 1920;

    public static PhotoOrientation getExifOrientation(ExifInterface exif) {
        int exifOrientationValue = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED);

        return PhotoOrientation.values()[exifOrientationValue];
    }

    enum PhotoOrientation {
        ORIENTATION_UNDEFINED, ORIENTATION_NORMAL, ORIENTATION_FLIP_HORIZONTAL, ORIENTATION_ROTATE_180,
        ORIENTATION_FLIP_VERTICAL, ORIENTATION_TRANSPOSE, ORIENTATION_ROTATE_90, ORIENTATION_TRANSVERSE, ORIENTATION_ROTATE_270
    }

    public static boolean ensurePortraitPhoto(File photoshotFile) {
        String origPhotoPath = photoshotFile.getAbsolutePath();

        BitmapFactory.Options origOptions = new BitmapFactory.Options();
        origOptions.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(origPhotoPath, origOptions);

        ExifInterface exif = null;
        try {
            exif = new ExifInterface(origPhotoPath);
        } catch (IOException e) {
            e.printStackTrace();

            return false;
        }

        int exifOrientation = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

        Log.d(TAG, "exif: " + getExifOrientationToDegrees(exifOrientation));

        if (exifOrientation == ExifInterface.ORIENTATION_NORMAL
                || exifOrientation == ExifInterface.ORIENTATION_UNDEFINED) {
            return true;
        }

        BitmapFactory.Options bmOptions = new BitmapFactory.Options();

        int scaleFactor = Math.min(origOptions.outWidth / PHOTO_HEIGHT, origOptions.outHeight / PHOTO_WIDTH);

        // Decode the bgThumbnail file into a Bitmap sized to fill the View
        bmOptions.inJustDecodeBounds = false;
        bmOptions.inSampleSize = scaleFactor;
        bmOptions.inPurgeable = true;

        Bitmap bitmap = BitmapFactory.decodeFile(origPhotoPath, bmOptions);

        int rotateDegree = getExifOrientationToDegrees(exifOrientation);
        Bitmap rotatedBitmap = rotate(bitmap, rotateDegree);
        FileOutputStream out = null;

        try {
            out = new FileOutputStream(photoshotFile);

            rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return true;
    }

    public static BitmapFactory.Options decodeBounds(String origPhotoPath) {
        BitmapFactory.Options origOptions = new BitmapFactory.Options();
        origOptions.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(origPhotoPath, origOptions);

        return origOptions;
    }

    public static ExifInterface getExifInfo(String origPhotoPath) {
        ExifInterface exif = null;

        try {
            exif = new ExifInterface(origPhotoPath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return exif;
    }

    private static int getExifOrientationToDegrees(int exifOrientation) {
        int retVal = 0;

        switch (exifOrientation) {
            case ExifInterface.ORIENTATION_ROTATE_90:
                retVal = 90;
                break;

            case ExifInterface.ORIENTATION_ROTATE_180:
                retVal = 180;
                break;

            case ExifInterface.ORIENTATION_ROTATE_270:
                retVal = 270;
                break;

        }

        return retVal;
    }

    private static Bitmap rotate(Bitmap bitmap, int degrees) {
        if (degrees != 0 && bitmap != null) {
            Matrix m = new Matrix();
            m.setRotate(degrees, (float) bitmap.getWidth() / 2,
                    (float) bitmap.getHeight() / 2);

            try {
                Bitmap converted = Bitmap.createBitmap(bitmap, 0, 0,
                        bitmap.getWidth(), bitmap.getHeight(), m, true);
                if (bitmap != converted) {
                    bitmap.recycle();
                    bitmap = converted;
                }
            } catch (OutOfMemoryError oome) {
                oome.printStackTrace();

                return null;
            }
        }

        return bitmap;
    }
}