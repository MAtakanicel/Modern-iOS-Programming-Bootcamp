import Foundation

struct RMCharacterPage: Codable, Equatable {
    struct PageInfo: Codable, Equatable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: PageInfo
    let results: [RMCharacter]
}

struct RMCharacter: Identifiable, Codable, Equatable, Hashable {
    struct SimpleLocation: Codable, Equatable, Hashable {
        let name: String
        let url: String
    }

    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: SimpleLocation
    let location: SimpleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}


