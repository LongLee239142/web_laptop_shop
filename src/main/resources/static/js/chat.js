let chatSessionId = localStorage.getItem('chatSessionId');

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const message = messageInput.value.trim();
    
    if (message === '') return;

    // Hiển thị tin nhắn của user
    appendMessage('user', message);
    messageInput.value = '';

    // Gửi tin nhắn lên server
    fetch('/chatbot/send', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `message=${encodeURIComponent(message)}&sessionId=${encodeURIComponent(chatSessionId || '')}`
    })
    .then(response => response.text())
    .then(reply => {
        const newSessionId = response.headers.get('X-Session-Id');
        if (newSessionId && !chatSessionId) {
            chatSessionId = newSessionId;
            localStorage.setItem('chatSessionId', chatSessionId);
        }

        // Hiển thị phản hồi của bot
        appendMessage('bot', reply);
    })
    .catch(error => {
        console.error('Error:', error);
        appendMessage('bot', 'Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau.');
    });
}

function appendMessage(sender, content) {
    const chatBox = document.getElementById('chatBox');
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${sender}-message`;
    
    const timestamp = new Date().toLocaleTimeString();
    messageDiv.innerHTML = `
        <span class="timestamp">${timestamp}</span>
        <span class="content">${content}</span>
    `;
    
    chatBox.appendChild(messageDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
}

// Xử lý khi nhấn Enter
document.getElementById('messageInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        sendMessage();
    }
}); 