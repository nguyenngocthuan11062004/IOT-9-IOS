//
//  OllamaResponse.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import Foundation

class OllamaAPI {
    static let shared = OllamaAPI()
    private let apiKey = "c5f2a3e5cbce46b8997a324413feb6eb.unBFUh12W-bXcwRYQ0xxekGv"

    func sendMessage(_ text: String) async throws -> String {
        guard let url = URL(string: "https://ollama.com/api/chat") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-oss:20b",
            "stream": false,
            "messages": [
                [
                    "role": "system",
                    "content": "Bạn là một trợ lý AI. Luôn trả lời bằng tiếng Việt, ngắn gọn, rõ ràng."
                ],
                [
                    "role": "user",
                    "content": text
                ]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OllamaResponse.self, from: data)
        return response.message.content
    }
}
struct OllamaResponse: Codable {
    let message: Message
    let done: Bool?

    struct Message: Codable {
        let role: String
        let content: String
        let thinking: String?
    }
}
