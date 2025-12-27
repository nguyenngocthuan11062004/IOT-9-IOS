//
//  OllamaAPI.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 13/12/25.
//

import Foundation

final class OllamaAPI {
    static let shared = OllamaAPI()
    private init() {}

    private let apiKey = "c5f2a3e5cbce46b8997a324413feb6eb.unBFUh12W-bXcwRYQ0xxekGv"
    private let endpoint = "https://ollama.com/api/chat"
    private let modelName = "gpt-oss:20b"

    // MARK: - Non-stream (lấy 1 phát ra luôn)
    func sendMessageWithHistory(
        _ messages: [[String: String]]
    ) async throws -> String {

        let request = try makeRequest(messages: messages, stream: false)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OllamaResponse.self, from: data)

        return response.message.content ?? ""
    }

    // MARK: - Stream (trả token dần dần)
    func streamMessageWithHistory(
        _ messages: [[String: String]],
        onToken: @escaping (String) -> Void
    ) async throws {

        let request = try makeRequest(messages: messages, stream: true)

        // bytes.lines đọc theo từng dòng (NDJSON)
        let (bytes, _) = try await URLSession.shared.bytes(for: request)

        for try await line in bytes.lines {
            guard let data = line.data(using: .utf8) else { continue }

            // Một số line có thể rỗng/keep-alive -> bỏ qua nếu decode fail
            guard let chunk = try? JSONDecoder().decode(OllamaResponse.self, from: data) else {
                continue
            }

            if let contentPiece = chunk.message.content, !contentPiece.isEmpty {
                onToken(contentPiece)
            }

            if chunk.done == true {
                break
            }
        }
    }

    // MARK: - Helper
    private func makeRequest(messages: [[String: String]], stream: Bool) throws -> URLRequest {
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60

        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": modelName,
            "stream": stream,
            "messages": messages
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }
}

// MARK: - Response Models
struct OllamaResponse: Codable {
    let message: Message
    let done: Bool?

    struct Message: Codable {
        let role: String?
        let content: String?
        let thinking: String?
    }
}
