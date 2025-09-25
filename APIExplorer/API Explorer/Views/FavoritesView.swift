import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var viewModel = CharactersListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.characters.filter { favorites.favoriteCharacterIds.contains($0.id) }) { character in
                    NavigationLink(value: character.id) {
                        CharacterRow(character: character)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Favoriler")
            .navigationDestination(for: Int.self) { id in
                CharacterDetailView(characterId: id)
            }
            .task {
                await loadFavoritesPagewise()
            }
        }
    }

    private func loadFavoritesPagewise() async {
        await MainActor.run { viewModel.refresh() }
        while case .loaded(let canLoadMore) = await MainActor.run(body: { viewModel.state }), canLoadMore {
            await MainActor.run { viewModel.loadMoreIfNeeded(currentItem: viewModel.characters.last) }
            try? await Task.sleep(nanoseconds: 150_000_000)
        }
    }
}


