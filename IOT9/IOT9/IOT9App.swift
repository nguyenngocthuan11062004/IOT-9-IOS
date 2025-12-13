//
//  IOT9App.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 11/12/25.
//

import SwiftUI
import Firebase
import Combine

@main
struct IOT9App: App {
    @StateObject private var appState = AppState()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Màn hình chính của ứng dụng
                Group {
                    if appState.hasSelectedLanguage {
                        MainView()
                            .environmentObject(appState)
                    } else {
                        SetLanguageView()
                            .environmentObject(appState)
                    }
                }
                // Bong bóng chat nổi
                FloatingChatBubble()
            }
            .onAppear {
                if appState.language.isEmpty,
                   let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
                    appState.language = savedLanguage
                    appState.hasSelectedLanguage = true
                }
            }
        }
    }
}

struct FloatingChatBubble: View {
    @State private var isChatOpen = false
    @State private var showChatView = false

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    // Mở màn hình chat khi nhấn vào bong bóng chat
                    isChatOpen.toggle()
                    showChatView = true
                }) {
                    Image(systemName: "message.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
                .sheet(isPresented: $showChatView) {
                    // Hiển thị màn hình ChatView khi người dùng nhấn vào bong bóng chat
                    ChatView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isChatOpen)
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasSelectedLanguage: Bool = false
    @Published var language: String = "" {
        didSet {
            // Lưu lại ngôn ngữ vào UserDefaults mỗi khi nó thay đổi
            UserDefaults.standard.set(language, forKey: "selectedLanguage")
            hasSelectedLanguage = true
        }
    }
}
