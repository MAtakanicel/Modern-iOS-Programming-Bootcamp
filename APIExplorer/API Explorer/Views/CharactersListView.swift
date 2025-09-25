import SwiftUI

struct CharactersListView: View {
    @StateObject private var viewModel = CharactersListViewModel()
    @State private var searchText: String = ""
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty:
                    VStack(spacing: 8) {
                        Text("Sonuç bulunamadı")
                        Button("Sıfırla") { viewModel.search("") }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .error(let message):
                    VStack(spacing: 8) {
                        Text("Hata: \(message)")
                        Button("Tekrar Dene") { viewModel.refresh() }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    list
                }
            }
            .navigationTitle("Karakterler")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Ada göre ara")
            .onChange(of: searchText) { _, newValue in
                debounceSearch(newValue)
            }
            .refreshable { viewModel.refresh() }
            .task { viewModel.initialLoad() }
        }
    }

    private var list: some View {
        List {
            ForEach(viewModel.characters) { character in
                HStack(spacing: 12) {
                    NavigationLink(value: character.id) {
                        CharacterRow(
                            character: character
                        )
                    }
                    Spacer()
                    Button(action: { favorites.toggleFavorite(id: character.id) }) {
                        Image(systemName: favorites.isFavorite(id: character.id) ? "star.fill" : "star")
                            .foregroundStyle(favorites.isFavorite(id: character.id) ? .yellow : .secondary)
                    }
                    .buttonStyle(.plain)
                }
                .onAppear { viewModel.loadMoreIfNeeded(currentItem: character) }
            }
            if case .loaded(let canLoadMore) = viewModel.state, canLoadMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Int.self) { id in
            CharacterDetailView(characterId: id)
        }
    }

    private func debounceSearch(_ text: String) {
        let current = text
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 400_000_000)
            if current == searchText {
                viewModel.search(current)
            }
        }
    }
}

struct CharacterRow: View {
    let character: RMCharacter

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: URL(string: character.image)) {
                AnyView(
                    Rectangle().fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                Text("\(character.species) • \(character.status)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}


