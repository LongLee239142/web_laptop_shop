package vn.hoidanit.laptopshop.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.hoidanit.laptopshop.service.impl.ChatServiceImpl;

@Controller
@RequestMapping(value = "/chatbot", produces = "text/plain;charset=UTF-8")
@ResponseBody
public class ChatController {

    @Autowired
    private ChatServiceImpl chatServiceImpl;

    @PostMapping("/send")
    public String sendMessage(@RequestParam("message") String message) {
        return chatServiceImpl.getReply(message);
    }
}
