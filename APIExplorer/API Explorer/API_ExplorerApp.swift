import SwiftUI

@main
struct API_ExplorerApp: App {
    @StateObject private var favorites = FavoritesStore()
    var body: some Scene {
        WindowGroup {
            TabView {
                CharactersListView()
                    .tabItem {
                        Label("Keşfet", systemImage: "list.bullet")
                    }
                FavoritesView()
                    .tabItem {
                        Label("Favoriler", systemImage: "star")
                    }
            }
            .environmentObject(favorites)
        }
    }
}
