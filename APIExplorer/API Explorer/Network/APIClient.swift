import Foundation

protocol CharactersServiceType {
    func fetchCharacters(page: Int?, nameQuery: String?) async throws -> RMCharacterPage
    func fetchCharacter(id: Int) async throws -> RMCharacter
}

enum APIClientError: Error, LocalizedError {
    case invalidURL
    case httpError(Int)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingFailed:
            return "Failed to decode response"
        case .unknown(let err):
            return err.localizedDescription
        }
    }
}

final class APIClient: CharactersServiceType {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    func fetchCharacters(page: Int? = nil, nameQuery: String? = nil) async throws -> RMCharacterPage {
        var components = URLComponents(url: baseURL.appendingPathComponent("character"), resolvingAgainstBaseURL: false)
        var queryItems: [URLQueryItem] = []
        if let page { queryItems.append(URLQueryItem(name: "page", value: String(page))) }
        if let nameQuery, !nameQuery.isEmpty { queryItems.append(URLQueryItem(name: "name", value: nameQuery)) }
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components?.url else { throw APIClientError.invalidURL }
        let (data, response) = try await urlSession.data(from: url)
        try Self.validate(response: response)
        do {
            return try jsonDecoder.decode(RMCharacterPage.self, from: data)
        } catch {
            throw APIClientError.decodingFailed
        }
    }

    func fetchCharacter(id: Int) async throws -> RMCharacter {
        let url = baseURL.appendingPathComponent("character/\(id)")
        let (data, response) = try await urlSession.data(from: url)
        try Self.validate(response: response)
        do {
            return try jsonDecoder.decode(RMCharacter.self, from: data)
        } catch {
            throw APIClientError.decodingFailed
        }
    }

    private static func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            throw APIClientError.httpError(http.statusCode)
        }
    }
}


