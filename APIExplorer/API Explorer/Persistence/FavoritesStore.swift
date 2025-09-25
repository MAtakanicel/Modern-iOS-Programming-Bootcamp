import Foundation

final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteCharacterIds: Set<Int>

    private let storageKey = "favoriteCharacterIds"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let saved = userDefaults.array(forKey: storageKey) as? [Int] {
            self.favoriteCharacterIds = Set(saved)
        } else {
            self.favoriteCharacterIds = []
        }
    }

    func isFavorite(id: Int) -> Bool {
        favoriteCharacterIds.contains(id)
    }

    func toggleFavorite(id: Int) {
        if favoriteCharacterIds.contains(id) {
            favoriteCharacterIds.remove(id)
        } else {
            favoriteCharacterIds.insert(id)
        }
        persist()
    }

    private func persist() {
        userDefaults.set(Array(favoriteCharacterIds), forKey: storageKey)
    }
}


