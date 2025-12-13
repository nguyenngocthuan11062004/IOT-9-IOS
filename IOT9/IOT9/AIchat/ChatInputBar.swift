//
//  ChatInputBar.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//
import SwiftUI
struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "camera")
            Image(systemName: "photo")
            Image(systemName: "folder")

            TextField("Text", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(20)

            Image(systemName: "mic")

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.green)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}
