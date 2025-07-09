package vn.longlee.laptopshop.service;

import java.util.List;

import vn.longlee.laptopshop.entity.ChatHistory;

public interface ChatService {
    String getReply(String message);
    List<ChatHistory> getChatHistory();
}
