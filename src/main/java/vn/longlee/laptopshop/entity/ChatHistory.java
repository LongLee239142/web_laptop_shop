package vn.longlee.laptopshop.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import vn.longlee.laptopshop.domain.User;

/**
 * Entity ánh xạ bảng chat_history (lịch sử chatbot).
 * Quan hệ: ChatHistory (N) ----> User (1) qua user_id. user_id có thể null (khách chưa đăng nhập).
 */
@Entity
@Table(name = "chat_history")
public class ChatHistory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String userMessage;
    private String botResponse;
    private LocalDateTime timestamp;
    
    /** N-1 với User: bảng chat_history có cột user_id (FK) trỏ tới users.id; có thể null */
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    public ChatHistory() {
        this.timestamp = LocalDateTime.now();
    }
    
    public ChatHistory(String userMessage, String botResponse) {
        this.userMessage = userMessage;
        this.botResponse = botResponse;
        this.timestamp = LocalDateTime.now();
    }
    
    public ChatHistory(String userMessage, String botResponse, User user) {
        this.userMessage = userMessage;
        this.botResponse = botResponse;
        this.user = user;
        this.timestamp = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserMessage() {
        return userMessage;
    }

    public void setUserMessage(String userMessage) {
        this.userMessage = userMessage;
    }

    public String getBotResponse() {
        return botResponse;
    }

    public void setBotResponse(String botResponse) {
        this.botResponse = botResponse;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
} 