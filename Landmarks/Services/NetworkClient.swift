//
//  NetworkClient.swift
//  Landmarks
//
//  A closure-based network client supporting all HTTP methods.
//  Each method is a closure that can be swapped for testing.
//

import Foundation

// MARK: - Network Client

struct NetworkClient: Sendable {
    var get: @Sendable (URL) async throws -> Data
    var post: @Sendable (URL, Data?) async throws -> Data
    var put: @Sendable (URL, Data?) async throws -> Data
    var delete: @Sendable (URL) async throws -> Data
}

// MARK: - Typed Convenience Methods

extension NetworkClient {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let data = try await get(url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func send<T: Decodable, B: Encodable>(_ type: T.Type, to url: URL, body: B, method: String = "POST") async throws -> T {
        let encoded = try JSONEncoder().encode(body)
        let data: Data
        switch method {
        case "PUT": data = try await put(url, encoded)
        default: data = try await post(url, encoded)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Live Implementation

extension NetworkClient {
    static var live: NetworkClient {
        let session = URLSession.shared

        return NetworkClient(
            get: { url in
                let (data, response) = try await session.data(from: url)
                try validateResponse(response)
                return data
            },
            post: { url, body in
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = body
                let (data, response) = try await session.data(for: request)
                try validateResponse(response)
                return data
            },
            put: { url, body in
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = body
                let (data, response) = try await session.data(for: request)
                try validateResponse(response)
                return data
            },
            delete: { url in
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                let (data, response) = try await session.data(for: request)
                try validateResponse(response)
                return data
            }
        )
    }
}

// MARK: - Mock Implementation

extension NetworkClient {
    static var mock: NetworkClient {
        NetworkClient(
            get: { url in
                try await Task.sleep(for: .milliseconds(500))
                let path = url.pathComponents.joined(separator: "/")
                if path.contains("landmarks") {
                    let encoder = JSONEncoder()
                    return try encoder.encode(LandmarkApiModel.mockApiResponse)
                }
                throw NetworkError.notFound
            },
            post: { _, _ in
                try await Task.sleep(for: .milliseconds(300))
                return Data()
            },
            put: { _, _ in
                try await Task.sleep(for: .milliseconds(300))
                return Data()
            },
            delete: { _ in
                try await Task.sleep(for: .milliseconds(300))
                return Data()
            }
        )
    }
}

// MARK: - Response Validation

private func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }

    switch httpResponse.statusCode {
    case 200...299:
        return
    case 404:
        throw NetworkError.notFound
    case 400...499:
        throw NetworkError.clientError(httpResponse.statusCode)
    case 500...599:
        throw NetworkError.serverError(httpResponse.statusCode)
    default:
        throw NetworkError.unknown(httpResponse.statusCode)
    }
}

// MARK: - Errors

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case notFound
    case clientError(Int)
    case serverError(Int)
    case unknown(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: "Invalid server response"
        case .notFound: "Resource not found"
        case .clientError(let code): "Client error (\(code))"
        case .serverError(let code): "Server error (\(code))"
        case .unknown(let code): "Unexpected error (\(code))"
        }
    }
}
