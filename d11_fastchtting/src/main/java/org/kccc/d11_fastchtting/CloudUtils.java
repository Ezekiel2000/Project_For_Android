package org.kccc.d11_fastchtting;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

/**
 * Created by Ezekiel on 2016. 12. 13..
 */

public class CloudUtils {
    private static final DatabaseReference refChatDb;
    private static String userName;

    static {
        FirebaseDatabase database = FirebaseDatabase.getInstance();
        database.setPersistenceEnabled(true);
        refChatDb = database.getReference("fastchat");
    }

    public static void init() {
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
        userName = String.format("%s (%s)",
                firebaseUser.getDisplayName(),
                firebaseUser.getEmail());
    }

    public static DatabaseReference getRefChatDb() {
        return refChatDb;
    }

    public static String getUserName() {
        return userName;
    }


    static FirebaseUser getFirebaseUser() {
        return FirebaseAuth.getInstance().getCurrentUser();
    }
}
