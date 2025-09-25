import Foundation

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded(RMCharacter)
        case error(String)
    }

    @Published private(set) var state: ViewState = .idle

    private let service: CharactersServiceType
    private let id: Int

    init(id: Int, service: CharactersServiceType = APIClient()) {
        self.id = id
        self.service = service
    }

    func load() {
        state = .loading
        Task {
            do {
                let character = try await service.fetchCharacter(id: id)
                self.state = .loaded(character)
            } catch {
                self.state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
            }
        }
    }
}


