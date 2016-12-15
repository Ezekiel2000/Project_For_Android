package org.kccc.d09_scrollingtest;

import android.os.Bundle;
import android.support.design.widget.AppBarLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import static android.support.design.widget.AppBarLayout.LayoutParams.SCROLL_FLAG_ENTER_ALWAYS;
import static android.support.design.widget.AppBarLayout.LayoutParams.SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED;
import static android.support.design.widget.AppBarLayout.LayoutParams.SCROLL_FLAG_EXIT_UNTIL_COLLAPSED;
import static android.support.design.widget.AppBarLayout.LayoutParams.SCROLL_FLAG_SCROLL;
import static android.support.design.widget.AppBarLayout.LayoutParams.SCROLL_FLAG_SNAP;

public class ScrollingActivity extends AppCompatActivity {

    AppBarLayout.LayoutParams layoutParams;

    private static final String[] MODE = {
            "(1) S_ (scroll)",
            "(2) S_ | ENTER_ALWAYS",
            "(3) S_ | ENTER_ALWAYS+COLLAPSED",
            "(4) S_ | EXIT_UNTIL_COLLAPSED",
            "(5) S_ | ENTER_ALWAYS | EXIT_UNTIL_COLLAPSED",
            "(6) S_ | ENTER_ALWAYS+COLLAPSED | EXIT_UNTIL_COLLAPSED",
            "(7+snap) S_ (scroll)",
            "(8+snap) S_ | ENTER_ALWAYS",
            "(9+snap) S_ | ENTER_ALWAYS+COLLAPSED",
            "(10+snap) S_ | EXIT_UNTIL_COLLAPSED",
            "(11+snap) S_ | ENTER_ALWAYS | EXIT_UNTIL_COLLAPSED",
            "(12+snap) S_ | ENTER_ALWAYS+COLLAPSED | EXIT_UNTIL_COLLAPSED",
    };

    private static final int[] FLAGS = {
            SCROLL_FLAG_SCROLL,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_SNAP,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_SNAP,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED | SCROLL_FLAG_SNAP,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED | SCROLL_FLAG_SNAP,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED | SCROLL_FLAG_SNAP,
            SCROLL_FLAG_SCROLL | SCROLL_FLAG_ENTER_ALWAYS | SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED | SCROLL_FLAG_EXIT_UNTIL_COLLAPSED | SCROLL_FLAG_SNAP,
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scrolling);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        AppBarLayout appBarLayout = (AppBarLayout) findViewById(R.id.app_bar);
        layoutParams = (AppBarLayout.LayoutParams) appBarLayout.getChildAt(0).getLayoutParams();

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                changeScrollParams(view);
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_scrolling, menu);
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

    int modeFlag = 0;

    public void changeScrollParams(View view) {
        if (++modeFlag == MODE.length) {
            modeFlag = 0;
        }

        layoutParams.setScrollFlags(FLAGS[modeFlag]);

        Snackbar.make(view, MODE[modeFlag], Snackbar.LENGTH_INDEFINITE).show();
    }

}
