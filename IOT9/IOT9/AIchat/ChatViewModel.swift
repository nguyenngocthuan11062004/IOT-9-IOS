//
//  ChatViewModel.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isSending: Bool = false

    func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isSending else { return }

        // Thêm tin nhắn user
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        inputText = ""
        isSending = true

        Task {
            do {
                let reply = try await OllamaAPI.shared.sendMessage(text)
                let botMessage = ChatMessage(text: reply, isUser: false)
                messages.append(botMessage)
            } catch {
                let errorMessage = ChatMessage(
                    text: "❌ Lỗi: \(error.localizedDescription)",
                    isUser: false
                )
                messages.append(errorMessage)
            }
            isSending = false
        }
    }
}
