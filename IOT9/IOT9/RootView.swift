//
//  RootView.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {

            if !appState.hasSelectedLanguage {
                SetLanguageView()
            } else {
                MainView()
            }
        }
    }
}
