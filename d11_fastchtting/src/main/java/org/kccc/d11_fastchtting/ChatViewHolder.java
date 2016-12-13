package org.kccc.d11_fastchtting;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

/**
 * Created by Ezekiel on 2016. 12. 13..
 */

public class ChatViewHolder extends RecyclerView.ViewHolder {
    ChatData chatData;
    TextView creator;
    TextView chat;

    public ChatViewHolder(View card) {
        super(card);

        creator = (TextView) card.findViewById(R.id.tvCreator);
        chat = (TextView) card.findViewById(R.id.tvChat);
    }
}
