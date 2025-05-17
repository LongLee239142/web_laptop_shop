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
    <div id="messages"></div>
    <div id="input-container">
        <input type="text" id="user-input" placeholder="Nhập tin nhắn...">
        <button id="send-btn">Gửi</button>
    </div>
</div>

<script>
    const input = document.getElementById("user-input");
    const messages = document.getElementById("messages");
    const sendBtn = document.getElementById("send-btn");
    const toggleBtn = document.getElementById("chat-toggle");
    const chatbox = document.getElementById("chatbox");

    const csrfToken = document.querySelector("meta[name='_csrf']").content;
    const csrfHeader = document.querySelector("meta[name='_csrf_header']").content;
    const chatUrl = "${chatUrl}";

    // Toggle chatbox hiển thị/ẩn
    toggleBtn.onclick = function () {
        if (chatbox.style.display === "none" || chatbox.style.display === "") {
            chatbox.style.display = "flex";
        } else {
            chatbox.style.display = "none";
        }
    };

    // Hiển thị tin nhắn
    function appendMessage(text, sender) {
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
</script>

</body>
</html>
