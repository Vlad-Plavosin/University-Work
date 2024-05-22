package com.javatechie.crud.example;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class MyWebSocketHandler extends TextWebSocketHandler {

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        System.out.println("Sending message to client: " + payload);

        // Optionally, you can log or inspect the message payload here

        // Call the superclass method to actually send the message to the client
        super.handleTextMessage(session, message);
    }
}