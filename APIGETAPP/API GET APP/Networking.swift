import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case badStatus(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL"
        case .transport(let err): return "Ağ hatası: \(err.localizedDescription)"
        case .badStatus(let code): return "Beklenmeyen durum kodu: \(code)"
        case .decoding(let err): return "Çözümleme hatası: \(err.localizedDescription)"
        }
    }
}

protocol APIClientProtocol {
    func fetchUsers() async throws -> [User]
}

struct APIClient: APIClientProtocol {
    private let session: URLSession
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchUsers() async throws -> [User] {
        guard let url = baseURL?.appendingPathComponent("users") else {
            throw APIError.invalidURL
        }
        do {
            let (data, response) = try await session.data(from: url)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw APIError.badStatus(http.statusCode)
            }
            do {
                return try JSONDecoder().decode([User].self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch {
            throw APIError.transport(error)
        }
    }
}


