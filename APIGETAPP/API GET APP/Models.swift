import Foundation

struct User: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

struct Address: Codable, Equatable, Hashable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo

    var formatted: String {
        "\(street), \(suite), \(city) \(zipcode)"
    }
}

struct Geo: Codable, Equatable, Hashable {
    let lat: String
    let lng: String
}

struct Company: Codable, Equatable, Hashable {
    let name: String
    let catchPhrase: String
    let bs: String
}


