<!-- Add at the end of body, before </body> -->
<style>
#chatbot-btn {
    position: fixed;
    bottom: 32px;
    right: 32px;
    width: 64px;
    height: 64px;
    background: #007bff;
    color: #fff;
    border-radius: 50%;
    border: none;
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    font-size: 2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1050;
    cursor: pointer;
    transition: background 0.2s;
}
#chatbot-btn:hover {
    background: #0056b3;
}
#chatbot-popup {
    position: fixed;
    bottom: 110px;
    right: 32px;
    width: 350px;
    max-width: 90vw;
    height: 450px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.18);
    display: none;
    flex-direction: column;
    z-index: 1051;
    border: 1px solid #ddd;
}
#chatbot-popup.active {
    display: flex;
}
#chatbot-header {
    background: #007bff;
    color: #fff;
    padding: 12px 16px;
    border-top-left-radius: 16px;
    border-top-right-radius: 16px;
    font-weight: 600;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
#chatbot-messages {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
    font-size: 0.97rem;
}
#chatbot-input-area {
    display: flex;
    border-top: 1px solid #eee;
    padding: 8px;
    background: #fafbfc;
}
#chatbot-input {
    flex: 1;
    border: 1px solid #ccc;
    border-radius: 8px;
    padding: 6px 10px;
    font-size: 1rem;
}
#chatbot-send {
    background: #007bff;
    color: #fff;
    border: none;
    border-radius: 8px;
    margin-left: 8px;
    padding: 6px 16px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s;
}
#chatbot-send:hover {
    background: #0056b3;
}
</style>

<!-- Chatbot Button -->
<button id="chatbot-btn" title="Ask AI">
    <i class="bi bi-robot"><span style="font-size:1.1rem;margin-right:4px;">🤖</span></i>
</button>

<!-- Chatbot Popup -->
<div id="chatbot-popup">
    <div id="chatbot-header">
        <span>AI Chatbot</span>
        <button type="button" id="chatbot-close" style="background:none;border:none;color:#fff;font-size:1.3rem;display:flex;align-items:center;">
            &times;
        </button>
    </div>
    <div id="chatbot-messages">
        <div style="color:#888;">Hi! Ask me anything about this website or your courses.</div>
    </div>
    <form id="chatbot-input-area" autocomplete="off">
        <input type="text" id="chatbot-input" placeholder="Type your question..." required />
        <button type="submit" id="chatbot-send">Send</button>
    </form>
</div>

<script>
document.getElementById('chatbot-btn').onclick = function() {
    document.getElementById('chatbot-popup').classList.add('active');
};
document.getElementById('chatbot-close').onclick = function() {
    document.getElementById('chatbot-popup').classList.remove('active');
};
document.getElementById('chatbot-input-area').onsubmit = async function(e) {
    e.preventDefault();
    const input = document.getElementById('chatbot-input');
    const msg = input.value.trim();
    if (!msg) return;
    const messages = document.getElementById('chatbot-messages');
    messages.innerHTML += `<div><b>You:</b> ${msg}</div>`;
    input.value = '';
    messages.scrollTop = messages.scrollHeight;

    // Call your AI backend (replace '/chatbot' with your actual endpoint)
    messages.innerHTML += `<div style="color:#888;"><i>AI is typing...</i></div>`;
    messages.scrollTop = messages.scrollHeight;
    try {
        const res = await fetch('${pageContext.request.contextPath}/chatbot', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({message: msg})
        });
        const data = await res.json();
        messages.innerHTML = messages.innerHTML.replace('<div style="color:#888;"><i>AI is typing...</i></div>', '');
        messages.innerHTML += `<div><b>AI:</b> ${data.reply}</div>`;
        messages.scrollTop = messages.scrollHeight;
    } catch (err) {
        messages.innerHTML += `<div style="color:red;">Sorry, I could not connect to the AI service.</div>`;
        messages.scrollTop = messages.scrollHeight;
    }
};
</script>