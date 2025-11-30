package vn.longlee.laptopshop.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.ChatHistory;
import vn.longlee.laptopshop.service.UserService;
import vn.longlee.laptopshop.service.impl.ChatServiceImpl;

@Controller
@RequestMapping("/chatbot")
public class ChatController {
    private static final Logger logger = LoggerFactory.getLogger(ChatController.class);

    @Autowired
    private ChatServiceImpl chatServiceImpl;

    @Autowired
    private UserService userService;

    @PostMapping(value = "/send", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String sendMessage(@RequestParam("message") String message, HttpSession session) {
        User currentUser = getCurrentUser(session);
        return chatServiceImpl.getReply(message, currentUser);
    }

    @GetMapping(value = "/history", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String getChatHistory(HttpSession session) {
        try {
            User currentUser = getCurrentUser(session);
            List<ChatHistory> history = chatServiceImpl.getChatHistoryByUser(currentUser);
            
            // Tạo JSON thủ công để tránh circular reference với User
            StringBuilder json = new StringBuilder("{\"success\":true,\"history\":[");
            for (int i = 0; i < history.size(); i++) {
                ChatHistory h = history.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"userMessage\":").append(escapeJson(h.getUserMessage())).append(",");
                json.append("\"botResponse\":").append(escapeJson(h.getBotResponse())).append(",");
                json.append("\"timestamp\":").append(h.getTimestamp() != null ? escapeJson(h.getTimestamp().toString()) : "null");
                json.append("}");
            }
            json.append("]}");
            return json.toString();
        } catch (Exception e) {
            return "{\"success\":false,\"message\":\"Lỗi khi lấy lịch sử chat\"}";
        }
    }

    @DeleteMapping(value = "/history", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String deleteChatHistory(HttpSession session) {
        try {
            User currentUser = getCurrentUser(session);
            if (currentUser == null) {
                return "{\"success\":false,\"message\":\"Bạn cần đăng nhập để xóa lịch sử chat\"}";
            }
            
            logger.info("Deleting chat history for user: {}", currentUser.getEmail());
            chatServiceImpl.deleteChatHistoryByUser(currentUser);
            logger.info("Successfully deleted chat history for user: {}", currentUser.getEmail());
            return "{\"success\":true,\"message\":\"Đã xóa lịch sử chat thành công\"}";
        } catch (Exception e) {
            logger.error("Error deleting chat history", e);
            return "{\"success\":false,\"message\":\"Lỗi khi xóa lịch sử chat: " + e.getMessage() + "\"}";
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "null";
        return "\"" + str.replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r")
                        .replace("\t", "\\t") + "\"";
    }

    private User getCurrentUser(HttpSession session) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.isAuthenticated() 
                    && !authentication.getName().equals("anonymousUser")) {
                String email = authentication.getName();
                return userService.getUserByEmail(email);
            }
            
            // Fallback: lấy từ session
            Long userId = (Long) session.getAttribute("id");
            if (userId != null) {
                return userService.getUserById(userId);
            }
        } catch (Exception e) {
            // Nếu không lấy được user, trả về null (user chưa đăng nhập)
        }
        return null;
    }
}
