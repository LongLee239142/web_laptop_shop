<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:url value="/chatbot/send" var="chatUrl" />
<html>
<head>
    <title>Chatbot</title>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <style>
       body {
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f4f7f9;
}

#chat-toggle {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 60px;
    height: 60px;
    background: #1abc63;
    color: white;
    border-radius: 50%;
    border: none;
    font-size: 26px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    transition: background 0.3s;
    z-index: 1000;
}

#chat-toggle:hover {
    background: #16A085;
}

#chatbox {
    position: fixed;
    bottom: 90px;
    right: 20px;
    width: 340px;
    height: 480px;
    background: #ffffff;
    border-radius: 16px;
    display: none;
    flex-direction: column;
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    overflow: hidden;
    z-index: 999;
}

#chat-header {
    background: #1abc63;
    color: white;
    padding: 12px 16px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-radius: 16px 16px 0 0;
}

#chat-header h3 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
}

#chat-header-actions {
    display: flex;
    gap: 8px;
}

#delete-history-btn {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    padding: 6px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 12px;
    transition: background 0.3s;
    display: flex;
    align-items: center;
    gap: 4px;
}

#delete-history-btn:hover {
    background: rgba(255, 255, 255, 0.3);
}

#delete-history-btn:active {
    background: rgba(255, 255, 255, 0.4);
}

/* Custom Confirm Modal */
.confirm-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 10000;
    animation: fadeIn 0.2s ease;
}

.confirm-modal-overlay.show {
    display: flex;
}

.confirm-modal {
    background: white;
    border-radius: 16px;
    padding: 0;
    max-width: 400px;
    width: 90%;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    animation: slideUp 0.3s ease;
    overflow: hidden;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.confirm-modal-header {
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
    color: white;
    padding: 20px;
    text-align: center;
}

.confirm-modal-header .icon {
    font-size: 48px;
    margin-bottom: 10px;
}

.confirm-modal-header h3 {
    margin: 0;
    font-size: 20px;
    font-weight: 600;
}

.confirm-modal-body {
    padding: 24px;
    text-align: center;
}

.confirm-modal-body p {
    margin: 0;
    color: #555;
    font-size: 15px;
    line-height: 1.6;
}

.confirm-modal-footer {
    padding: 16px 24px;
    display: flex;
    gap: 12px;
    justify-content: flex-end;
    border-top: 1px solid #e1e8ed;
    background: #f8f9fa;
}

.confirm-modal-btn {
    padding: 10px 24px;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    min-width: 100px;
}

.confirm-modal-btn-cancel {
    background: #e1e8ed;
    color: #495057;
}

.confirm-modal-btn-cancel:hover {
    background: #d1d9de;
    transform: translateY(-1px);
}

.confirm-modal-btn-delete {
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
    color: white;
}

.confirm-modal-btn-delete:hover {
    background: linear-gradient(135deg, #ff5252 0%, #e53935 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(255, 107, 107, 0.4);
}

.confirm-modal-btn:active {
    transform: translateY(0);
}

#messages {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
    font-size: 14px;
    background: #ecf0f1;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.message {
    padding: 10px 14px;
    max-width: 80%;
    border-radius: 18px;
    word-wrap: break-word;
    line-height: 1.4;
}

.user {
    align-self: flex-end;
    background: #1abc63;
    color: white;
    border-bottom-right-radius: 4px;
}

.bot {
    align-self: flex-start;
    background: #dce1e3;
    color: #2C3E50;
    border-bottom-left-radius: 4px;
}

.welcome-message {
    text-align: center;
    padding: 20px;
    color: #6c757d;
    font-style: italic;
}

#input-container {
    display: flex;
    border-top: 1px solid #ccc;
    padding: 10px;
    background: #fff;
}

#user-input {
    flex: 1;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 10px;
    outline: none;
    font-size: 14px;
}

#send-btn {
    margin-left: 10px;
    padding: 10px 16px;
    border: none;
    background: #1abc63;
    color: white;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.3s;
}

#send-btn:hover {
    background: #16A085;
}

    </style>
</head>
<body>

<!-- Nút mở/đóng chat -->
<button id="chat-toggle">💬</button>

<!-- Hộp chat -->
<div id="chatbox">
    <div id="chat-header">
        <h3>💬 Liên hệ tư vấn</h3>
        <div id="chat-header-actions">
            <button id="delete-history-btn" title="Xóa lịch sử chat">🗑️ Xóa</button>
        </div>
    </div>
    <div id="messages">
        <div class="welcome-message">
            <p>👋 Xin chào! Tôi có thể giúp gì cho bạn?</p>
        </div>
    </div>
    <div id="input-container">
        <input type="text" id="user-input" placeholder="Nhập tin nhắn...">
        <button id="send-btn">Gửi</button>
    </div>
</div>

<!-- Custom Confirm Modal -->
<div id="confirm-modal-overlay" class="confirm-modal-overlay">
    <div class="confirm-modal">
        <div class="confirm-modal-header">
            <div class="icon">🗑️</div>
            <h3>Xóa lịch sử chat</h3>
        </div>
        <div class="confirm-modal-body">
            <p>Bạn có chắc chắn muốn xóa toàn bộ lịch sử chat không?</p>
            <p style="margin-top: 8px; font-size: 13px; color: #888;">Hành động này không thể hoàn tác.</p>
        </div>
        <div class="confirm-modal-footer">
            <button class="confirm-modal-btn confirm-modal-btn-cancel" id="confirm-cancel-btn">Hủy</button>
            <button class="confirm-modal-btn confirm-modal-btn-delete" id="confirm-delete-btn">Xóa</button>
        </div>
    </div>
</div>

<script>
    const input = document.getElementById("user-input");
    const messages = document.getElementById("messages");
    const sendBtn = document.getElementById("send-btn");
    const toggleBtn = document.getElementById("chat-toggle");
    const chatbox = document.getElementById("chatbox");
    const deleteHistoryBtn = document.getElementById("delete-history-btn");
    const confirmModalOverlay = document.getElementById("confirm-modal-overlay");
    const confirmCancelBtn = document.getElementById("confirm-cancel-btn");
    const confirmDeleteBtn = document.getElementById("confirm-delete-btn");

    const csrfToken = document.querySelector("meta[name='_csrf']").content;
    const csrfHeader = document.querySelector("meta[name='_csrf_header']").content;
    const chatUrl = "${chatUrl}";
    const historyUrl = "/chatbot/history";
    const deleteHistoryUrl = "/chatbot/history";
    let historyLoaded = false;

    // Load lịch sử chat
    function loadChatHistory() {
        if (historyLoaded) return;
        
        fetch(historyUrl, {
            method: "GET",
            headers: {
                "Content-Type": "application/json"
            }
        })
        .then(res => {
            if (!res.ok) {
                throw new Error("HTTP error " + res.status);
            }
            return res.json();
        })
        .then(data => {
            historyLoaded = true;
            if (data.success && data.history && data.history.length > 0) {
                // Xóa welcome message nếu có
                const welcomeMsg = messages.querySelector(".welcome-message");
                if (welcomeMsg) {
                    welcomeMsg.remove();
                }
                
                // Hiển thị lịch sử chat
                data.history.forEach(item => {
                    appendMessage(item.userMessage, "user");
                    appendMessage(item.botResponse, "bot");
                });
            }
        })
        .catch(error => {
            console.log("Không thể load lịch sử chat:", error);
            // Không hiển thị lỗi cho user, chỉ log
        });
    }

    // Toggle chatbox hiển thị/ẩn
    toggleBtn.onclick = function () {
        if (chatbox.style.display === "none" || chatbox.style.display === "") {
            chatbox.style.display = "flex";
            // Load lịch sử khi mở chatbox
            loadChatHistory();
        } else {
            chatbox.style.display = "none";
        }
    };

    // Hiển thị tin nhắn
    function appendMessage(text, sender) {
        // Xóa welcome message nếu có khi user gửi tin nhắn đầu tiên
        if (sender === "user") {
            const welcomeMsg = messages.querySelector(".welcome-message");
            if (welcomeMsg) {
                welcomeMsg.remove();
            }
        }
        
        const div = document.createElement("div");
        div.className = "message " + sender;
        div.textContent = text;
        messages.appendChild(div);
        messages.scrollTop = messages.scrollHeight;
    }

    // Gửi tin nhắn
    sendBtn.onclick = function () {
        const msg = input.value.trim();
        if (msg === "") return;
        appendMessage(msg, "user");
        input.value = "";

        fetch(chatUrl, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                [csrfHeader]: csrfToken
            },
            body: "message=" + encodeURIComponent(msg)
        })
        .then(res => {
            if (!res.ok) {
                throw new Error("HTTP error " + res.status);
            }
            return res.text();
        })
        .then(response => {
            appendMessage(response, "bot");
        })
        .catch(error => {
            appendMessage("Đã xảy ra lỗi: " + error.message, "bot");
        });
    };

    // Gửi bằng phím Enter
    input.addEventListener("keypress", function (e) {
        if (e.key === "Enter") sendBtn.click();
    });

    // Hiển thị confirm modal
    function showConfirmModal() {
        confirmModalOverlay.classList.add("show");
    }

    // Ẩn confirm modal
    function hideConfirmModal() {
        confirmModalOverlay.classList.remove("show");
    }

    // Xử lý xóa lịch sử chat
    function deleteChatHistory() {
        hideConfirmModal();
        
        fetch(deleteHistoryUrl, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                [csrfHeader]: csrfToken
            }
        })
        .then(res => {
            if (!res.ok) {
                throw new Error("HTTP error " + res.status);
            }
            return res.json();
        })
        .then(data => {
            if (data.success) {
                // Xóa tất cả tin nhắn hiện tại
                messages.innerHTML = '';
                
                // Hiển thị welcome message
                const welcomeDiv = document.createElement("div");
                welcomeDiv.className = "welcome-message";
                welcomeDiv.innerHTML = "<p>👋 Xin chào! Tôi có thể giúp gì cho bạn?</p>";
                messages.appendChild(welcomeDiv);
                
                // Reset flag để có thể load lại lịch sử nếu cần
                historyLoaded = false;
                
                // Scroll to top
                messages.scrollTop = 0;
            } else {
                alert(data.message || "Có lỗi xảy ra khi xóa lịch sử chat");
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Có lỗi xảy ra khi xóa lịch sử chat. Vui lòng thử lại sau.");
        });
    }

    // Xóa lịch sử chat - mở modal
    deleteHistoryBtn.addEventListener("click", function() {
        showConfirmModal();
    });

    // Hủy xóa
    confirmCancelBtn.addEventListener("click", function() {
        hideConfirmModal();
    });

    // Xác nhận xóa
    confirmDeleteBtn.addEventListener("click", function() {
        deleteChatHistory();
    });

    // Đóng modal khi click vào overlay
    confirmModalOverlay.addEventListener("click", function(e) {
        if (e.target === confirmModalOverlay) {
            hideConfirmModal();
        }
    });

    // Đóng modal bằng phím ESC
    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape" && confirmModalOverlay.classList.contains("show")) {
            hideConfirmModal();
        }
    });
</script>

</body>
</html>
