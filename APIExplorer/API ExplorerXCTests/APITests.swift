import XCTest
import Combine
@testable import API_Explorer

final class CharacterDecodingTests: XCTestCase {
    func testDecodeCharacterPage() throws {
        let json = """
        {"info":{"count":1,"pages":1,"next":null,"prev":null},"results":[{"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth","url":""},"location":{"name":"Earth","url":""},"image":"https://example.com/rick.png","episode":["e1"],"url":"","created":"2017-11-04T18:48:46.250Z"}]}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(RMCharacterPage.self, from: json)
        XCTAssertEqual(decoded.results.first?.name, "Rick Sanchez")
        XCTAssertEqual(decoded.info.count, 1)
    }
}

@MainActor
final class CharactersListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testInitialLoadSetsLoadedStateAndItems() async {
        let exp = expectation(description: "initial load completes")
        let mock = MockService()
        let viewModel = CharactersListViewModel(service: mock)

        // Durum loaded olduğunda expectation'ı karşıla
        viewModel.$state
            .dropFirst() // idle'dan sonraki değişimleri izle
            .sink { state in
                if case .loaded = state { exp.fulfill() }
            }
            .store(in: &cancellables)

        // Yüklemeyi başlat
        viewModel.initialLoad()

        await fulfillment(of: [exp], timeout: 2.0)

        // Bekleme sonrası doğrulamalar
        if case .loaded(let canLoadMore) = viewModel.state {
            XCTAssertFalse(canLoadMore)
        } else {
            XCTFail("State should be .loaded")
        }
        XCTAssertEqual(viewModel.characters.count, 1)
    }
}

// MARK: - Test Helpers

final class MockService: CharactersServiceType {
    func fetchCharacters(page: Int?, nameQuery: String?) async throws -> RMCharacterPage {
        let character = RMCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: .init(name: "Earth", url: ""),
            location: .init(name: "Earth", url: ""),
            image: "https://example.com/rick.png",
            episode: ["e1"],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )
        return RMCharacterPage(info: .init(count: 1, pages: 1, next: nil, prev: nil), results: [character])
    }

    func fetchCharacter(id: Int) async throws -> RMCharacter {
        return RMCharacter(
            id: id,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: .init(name: "Earth", url: ""),
            location: .init(name: "Earth", url: ""),
            image: "https://example.com/rick.png",
            episode: ["e1"],
            url: "",
            created: "2017-11-04T18:48:46.250Z"
        )
    }
}


