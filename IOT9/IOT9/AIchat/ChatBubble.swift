//
//  ChatBubble.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.text)
                .padding(12)
                .background(
                    message.isUser
                    ? Color(red: 32/255, green: 163/255, blue: 41/255)
                    : Color.gray.opacity(0.2)
                )
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(16)
                .frame(maxWidth: 260, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
