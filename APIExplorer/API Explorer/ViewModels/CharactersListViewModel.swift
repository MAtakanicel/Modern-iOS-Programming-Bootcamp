import Foundation

@MainActor
final class CharactersListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded(canLoadMore: Bool)
        case empty
        case error(String)
    }

    @Published private(set) var characters: [RMCharacter] = []
    @Published var searchQuery: String = ""
    @Published private(set) var state: ViewState = .idle

    private let service: CharactersServiceType
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private var loadTask: Task<Void, Never>?

    init(service: CharactersServiceType = APIClient()) {
        self.service = service
    }

    func refresh() {
        currentPage = 1
        canLoadMore = true
        characters.removeAll()
        load(search: searchQuery, isRefreshing: true)
    }

    func search(_ text: String) {
        searchQuery = text
        currentPage = 1
        canLoadMore = true
        characters.removeAll()
        load(search: text, isRefreshing: false)
    }

    func loadMoreIfNeeded(currentItem: RMCharacter?) {
        guard let currentItem else { return }
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5, limitedBy: characters.startIndex) ?? characters.startIndex
        if characters.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            load(search: searchQuery, isRefreshing: false)
        }
    }

    func initialLoad() {
        guard characters.isEmpty else { return }
        load(search: searchQuery, isRefreshing: false)
    }

    private func load(search: String, isRefreshing: Bool) {
        guard canLoadMore, loadTask == nil else { return }
        state = characters.isEmpty ? .loading : state
        loadTask = Task { [weak self] in
            guard let self else { return }
            defer { self.loadTask = nil }
            do {
                let page = try await service.fetchCharacters(page: currentPage, nameQuery: search.isEmpty ? nil : search)
                if isRefreshing { self.characters = page.results } else { self.characters.append(contentsOf: page.results) }
                self.canLoadMore = page.info.next != nil
                if self.characters.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .loaded(canLoadMore: self.canLoadMore)
                }
                if self.canLoadMore { self.currentPage += 1 }
            } catch {
                if self.characters.isEmpty {
                    self.state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
                } else {
                    self.state = .loaded(canLoadMore: self.canLoadMore)
                }
            }
        }
    }
}


