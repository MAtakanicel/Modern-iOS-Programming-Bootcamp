import SwiftUI
import SwiftData
import MapKit

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteLocation.createdAt, order: .reverse) private var favorites: [FavoriteLocation]
    
    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "Henüz Favori Yok",
                        systemImage: "mappin.slash",
                        description: Text("Haritadan bir konuma dokunarak favori ekleyebilirsiniz")
                    )
                } else {
                    List {
                        ForEach(favorites) { favorite in
                            FavoriteLocationRow(favorite: favorite)
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                }
            }
            .navigationTitle("Favori Konumlar")
            .toolbar {
                if !favorites.isEmpty {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
}

struct FavoriteLocationRow: View {
    let favorite: FavoriteLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(.red)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(favorite.name)
                        .font(.headline)
                    
                    Text(favorite.address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(
                            String(format: "%.6f", favorite.latitude),
                            systemImage: "location.north.fill"
                        )
                        
                        Label(
                            String(format: "%.6f", favorite.longitude),
                            systemImage: "location.fill"
                        )
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            
            // Mini harita önizlemesi
            Map(initialPosition: .region(MKCoordinateRegion(
                center: favorite.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))) {
                Marker(favorite.name, coordinate: favorite.coordinate)
                    .tint(.red)
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(false) // Listedeki dokunmaları engellememek için
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: FavoriteLocation.self, inMemory: true)
}

