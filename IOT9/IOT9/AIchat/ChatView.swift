//
//  ChatView.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = ChatViewModel()

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
            .padding()
            .background(Color.white)

            Divider()

            // MARK: - Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(vm.messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.top, 8)
                }
                .background(Color.white)
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // MARK: - Input Bar
            HStack(spacing: 14) {

                Image(systemName: "camera")
                Image(systemName: "photo")
                Image(systemName: "folder")

                TextField("Text", text: $vm.inputText)
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
                .disabled(vm.inputText.isEmpty || vm.isSending)
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
    }
}

#Preview {
    ChatView()
}
