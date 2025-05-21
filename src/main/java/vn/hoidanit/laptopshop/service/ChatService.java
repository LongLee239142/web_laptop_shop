package vn.hoidanit.laptopshop.service;

import java.util.List;

import vn.hoidanit.laptopshop.entity.ChatHistory;

public interface ChatService {
    String getReply(String message);
    List<ChatHistory> getChatHistory();
}
