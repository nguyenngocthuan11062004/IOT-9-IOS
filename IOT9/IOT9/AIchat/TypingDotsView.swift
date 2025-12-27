//
//  TypingDotsView.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import SwiftUI

struct TypingDotsView: View {
    @State private var scale: CGFloat = 0.5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 6, height: 6)
                    .scaleEffect(scale)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: scale
                    )
            }
        }
        .onAppear {
            scale = 1
        }
    }
}
