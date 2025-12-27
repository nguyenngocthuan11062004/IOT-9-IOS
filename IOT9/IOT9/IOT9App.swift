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
    @StateObject private var chatVM = ChatViewModel()

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
                    chatVM.prefetchPlantContext(
                        temperature: 31.2,
                        humidity: 68,
                        isRaining: false
                    )

                    chatVM.autoAskPlantAdviceIfNeeded() // GỬI CÂU HỎI NGẦM

                    showChatView = true
                } label: {
                    Image("ai_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                        .padding(14)
                        .background(Color.white) // hoặc Color(red: 32/255, green: 163/255, blue: 41/255)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .offset(y: -100)
                .sheet(isPresented: $showChatView) {
                    ChatView(vm: chatVM)
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
