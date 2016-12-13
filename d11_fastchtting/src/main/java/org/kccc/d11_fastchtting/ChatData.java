package org.kccc.d11_fastchtting;

/**
 * Created by Ezekiel on 2016. 12. 13..
 */

public class ChatData {
    private String name;

    private String chat;

    public ChatData() {

    }

    public ChatData(String _chat) {
        name = CloudUtils.getUserName();
        chat = _chat;
    }

    public String getName() {
        return name;
    }

    public String getChat() {
        return chat;
    }
}
