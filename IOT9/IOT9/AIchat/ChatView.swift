//
//  ChatView.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ChatViewModel

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }

                Spacer()

                Text("Chatbot")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)

                Spacer()

                Color.clear.frame(width: 24)
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .background(Color.white)

            Divider()

            // MARK: - Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 4) {

                        // Tin nhắn đã gửi
                        ForEach(vm.messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }

                        // AI đang phân tích (Typing indicator)
                        if vm.isStreaming && vm.streamingText.isEmpty {
                            HStack {
                                Text("AI đang phân tích")
                                    .font(.footnote)
                                    .foregroundColor(.gray)

                                TypingDotsView()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .id("typing_indicator")
                        }

                        // AI đang stream nội dung
                        if vm.isStreaming && !vm.streamingText.isEmpty {
                            ChatBubble(
                                message: ChatMessage(
                                    text: vm.streamingText,
                                    isUser: false
                                )
                            )
                            .id("streaming_message")
                        }
                    }
                    .padding(.top, 8)
                }
                .background(Color.white)
                .onChange(of: vm.messages.count) { _ in
                    scrollToBottom(proxy)
                }
                .onChange(of: vm.streamingText) { _ in
                    scrollToBottom(proxy)
                }
            }

            Divider()

            // MARK: - Input Bar
            HStack(spacing: 14) {

                Image(systemName: "camera")
                Image(systemName: "photo")
                Image(systemName: "folder")

                TextField("Text", text: $vm.inputText)
                    .disabled(vm.isStreaming) // 🔒 chặn nhập khi AI đang trả lời
                    .opacity(vm.isStreaming ? 0.6 : 1)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)

                Image(systemName: "mic")

                Button {
                    vm.send()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                .disabled(
                    vm.inputText.isEmpty || vm.isStreaming
                )
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                Color.white
                    .shadow(color: .black.opacity(0.05), radius: 4, y: -2)
            )
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }

    // MARK: - Auto scroll helper
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(.easeOut) {
                if vm.isStreaming {
                    if vm.streamingText.isEmpty {
                        proxy.scrollTo("typing_indicator", anchor: .bottom)
                    } else {
                        proxy.scrollTo("streaming_message", anchor: .bottom)
                    }
                } else if let last = vm.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }
}
