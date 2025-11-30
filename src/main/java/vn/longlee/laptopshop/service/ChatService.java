package vn.longlee.laptopshop.service;

import java.util.List;

import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.ChatHistory;

public interface ChatService {
    String getReply(String message);
    String getReply(String message, User user);
    List<ChatHistory> getChatHistory();
    List<ChatHistory> getChatHistoryByUser(User user);
    void deleteChatHistoryByUser(User user);
}
