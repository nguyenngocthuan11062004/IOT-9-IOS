//
//  SetLanguageView.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//
import SwiftUI

struct SetLanguageView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLanguage: String = "en"

    var body: some View {
        ZStack {
            // Background image
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Optional overlay để chữ dễ đọc
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button {
                        // Lưu ngôn ngữ vào appState và UserDefaults
                        appState.language = selectedLanguage
                        appState.hasSelectedLanguage = true
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 32)
                .padding(.trailing, 20)

                VStack(spacing: 16) {

                    LanguageRow(
                        flag: "🇬🇧",
                        title: "English",
                        isSelected: selectedLanguage == "en"
                    ) {
                        selectedLanguage = "en"
                    }

                    LanguageRow(
                        flag: "🇻🇳",
                        title: "Vietnamese",
                        isSelected: selectedLanguage == "vi"
                    ) {
                        selectedLanguage = "vi"
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            // Nếu đã có ngôn ngữ được lưu trong appState, thì không cần phải chọn lại
            if appState.hasSelectedLanguage {
                selectedLanguage = appState.language
            }
        }
    }
}

// MARK: - ROW
struct LanguageRow: View {
    let flag: String
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(flag)
                    .font(.system(size: 28))

                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .medium))

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.green.opacity(0.5) : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, y: 3)
        }
    }
}
