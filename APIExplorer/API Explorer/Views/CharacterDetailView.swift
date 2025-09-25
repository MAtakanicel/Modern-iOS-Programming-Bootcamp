import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @EnvironmentObject private var favorites: FavoritesStore

    init(characterId: Int) {
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(id: characterId))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message):
                VStack(spacing: 8) {
                    Text("Hata: \(message)")
                    Button("Tekrar Dene") { viewModel.load() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded(let character):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CachedAsyncImage(url: URL(string: character.image)) {
                            AnyView(Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 260))
                        }
                        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
                        .clipped()

                        VStack(alignment: .leading, spacing: 8) {
                            Text(character.name)
                                .font(.largeTitle.bold())
                                .overlay(alignment: .trailing) {
                                    Button(action: { favorites.toggleFavorite(id: character.id) }) {
                                        Image(systemName: favorites.isFavorite(id: character.id) ? "star.fill" : "star")
                                            .foregroundStyle(favorites.isFavorite(id: character.id) ? .yellow : .secondary)
                                    }
                                }
                            Text("\(character.species) • \(character.status)")
                                .font(.headline)
                                .foregroundStyle(.secondary)

                            infoRow(title: "Cinsiyet", value: character.gender)
                            infoRow(title: "Origin", value: character.origin.name)
                            infoRow(title: "Konum", value: character.location.name)
                            infoRow(title: "Bölüm Sayısı", value: String(character.episode.count))
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle(character.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task { viewModel.load() }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.body)
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


