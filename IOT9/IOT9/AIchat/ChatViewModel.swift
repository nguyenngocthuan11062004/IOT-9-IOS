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

    // MARK: - UI State
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""

    // Streaming / Thinking
    @Published var isStreaming: Bool = false          // 🔒 chặn input
    @Published var streamingText: String = ""         // text AI đang gõ

    // MARK: - Conversation History (RẤT QUAN TRỌNG)
    private var conversationHistory: [[String: String]] = [
        [
            "role": "system",
            "content": """
            Bạn là trợ lý nông nghiệp thông minh.

            QUY TẮC BẮT BUỘC:
            - Luôn trả lời bằng tiếng Việt
            - Luôn dùng đúng format sau (không thêm, không bớt):

             Nhiệt độ hiện tại: <giá trị>°C
             Độ ẩm: <giá trị>%
             Thời tiết: Có mưa / Không mưa

             Kết luận: CÓ hoặc KHÔNG cần tưới cây
             Gợi ý: Để tư vấn chính xác hơn, hãy cho tôi biết loại cây bạn đang trồng.

            - Không giải thích dài dòng
            - Không hỏi câu khác ngoài câu hỏi về loại cây
            """
        ]
    ]


    // MARK: - Prefetch context (KHÔNG gọi API)
    func prefetchPlantContext(
        temperature: Double,
        humidity: Double,
        isRaining: Bool
    ) {
        let context = """
        Nhiệt độ ngoài trời hiện tại là \(temperature)°C,
        độ ẩm là \(humidity)%,
        thời tiết hiện tại \(isRaining ? "đang mưa" : "không mưa").

        Hãy suy luận xem có cần tưới cây hay không.
        Nếu cần thêm thông tin, hãy hỏi người dùng loại cây.
        """

        conversationHistory.append([
            "role": "system",
            "content": context
        ])
    }
    func autoAskPlantAdviceIfNeeded() {
        guard messages.isEmpty, !isStreaming else { return }

        let autoQuestion = "Dựa trên dữ liệu hiện tại, tôi có cần tưới cây không?"

        // append như user nhưng KHÔNG hiện input
        messages.append(ChatMessage(text: autoQuestion, isUser: true))

        conversationHistory.append([
            "role": "user",
            "content": autoQuestion
        ])

        isStreaming = true
        streamingText = ""

        Task {
            do {
                try await OllamaAPI.shared.streamMessageWithHistory(
                    conversationHistory
                ) { token in
                    Task { @MainActor in
                        self.streamingText += token
                    }
                }

                let finalText = streamingText
                messages.append(ChatMessage(text: finalText, isUser: false))

                conversationHistory.append([
                    "role": "assistant",
                    "content": finalText
                ])

            } catch {
                messages.append(
                    ChatMessage(
                        text: "❌ Lỗi: \(error.localizedDescription)",
                        isUser: false
                    )
                )
            }

            isStreaming = false
            streamingText = ""
        }
    }


    // MARK: - Send message (STREAMING)
    func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isStreaming else { return }

        // 1️⃣ Append message của user
        messages.append(ChatMessage(text: text, isUser: true))
        inputText = ""

        conversationHistory.append([
            "role": "user",
            "content": text
        ])

        // 2️⃣ Bắt đầu streaming
        isStreaming = true
        streamingText = ""

        Task {
            do {
                try await OllamaAPI.shared.streamMessageWithHistory(
                    conversationHistory
                ) { token in
                    Task { @MainActor in
                        self.streamingText += token
                    }
                }

                // 3️⃣ Streaming xong → chốt message AI
                let finalText = streamingText

                messages.append(
                    ChatMessage(text: finalText, isUser: false)
                )

                conversationHistory.append([
                    "role": "assistant",
                    "content": finalText
                ])

            } catch {
                messages.append(
                    ChatMessage(
                        text: "❌ Lỗi: \(error.localizedDescription)",
                        isUser: false
                    )
                )
            }

            // 4️⃣ Mở lại input
            isStreaming = false
            streamingText = ""
        }
    }

    // MARK: - Reset chat (nếu cần)
    func resetConversation() {
        messages.removeAll()
        streamingText = ""
        isStreaming = false

        conversationHistory = [
            [
                "role": "system",
                "content": "Bạn là trợ lý nông nghiệp thông minh. Trả lời bằng tiếng Việt, ngắn gọn, rõ ràng."
            ]
        ]
    }
}
