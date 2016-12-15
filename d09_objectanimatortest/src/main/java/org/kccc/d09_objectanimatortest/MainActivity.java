package org.kccc.d09_objectanimatortest;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        ObjectAnimator animScaleX1 = ObjectAnimator.ofFloat(fab, "scaleX", 1.0f, 1.2f);
        ObjectAnimator animScaleY1 = ObjectAnimator.ofFloat(fab, "scaleY", 1.0f, 1.2f);
        ObjectAnimator animAlpha1 = ObjectAnimator.ofFloat(fab, "alpha", 1.0f, 0.0f);
        ObjectAnimator animRotate1 = ObjectAnimator.ofFloat(fab, "rotation", 0, 360);

        final AnimatorSet animSet1 = new AnimatorSet();
        animSet1.setDuration(500);
        animSet1.playTogether(animScaleX1, animScaleY1, animAlpha1, animRotate1);

        ObjectAnimator animScaleX2 = ObjectAnimator.ofFloat(fab, "scaleX", 1.2f, 1.0f);
        ObjectAnimator animScaleY2 = ObjectAnimator.ofFloat(fab, "scaleY", 1.2f, 1.0f);
        ObjectAnimator animAlpha2 = ObjectAnimator.ofFloat(fab, "alpha", 0.0f, 1.0f);
        ObjectAnimator animRotate2 = ObjectAnimator.ofFloat(fab, "rotation", 360, 0);

        final AnimatorSet animSet2 = new AnimatorSet();
        animSet2.setDuration(500);
        animSet2.playTogether(animScaleX2, animScaleY2, animAlpha2, animRotate2);

        fab.setOnClickListener(new View.OnClickListener() {
            boolean check = false;
            @Override
            public void onClick(View view) {
                if (check = !check) {
                    animSet1.start();
                } else {
                    animSet2.start();
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
