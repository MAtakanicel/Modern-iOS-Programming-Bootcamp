import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteLocation]
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showingAddSheet = false
    @State private var newLocationName = ""
    @State private var newLocationAddress = ""
    @State private var isGeocodingNewLocation = false
    @State private var showFavorites = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Harita
                Map(position: $cameraPosition) {
                    // Kullanıcının konumu
                    if let location = locationManager.location {
                        Marker("Konumum", coordinate: location.coordinate)
                            .tint(.blue)
                    }
                    
                    // Favori konumlar
                    ForEach(favorites) { favorite in
                        Marker(favorite.name, coordinate: favorite.coordinate)
                            .tint(.red)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onMapCameraChange { context in
                    // Kamera değişikliklerini takip edebilirsiniz
                }
                .onTapGesture { screenCoordinate in
                    // Not: onTapGesture coordinate almıyor, bu yüzden LongPressGesture kullanacağız
                }
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag):
                                if let location = drag?.location {
                                    handleMapTap(at: location)
                                }
                            default:
                                break
                            }
                        }
                )
                
                // Konum bilgisi kartı
                if let location = locationManager.location {
                    VStack(spacing: 0) {
                        LocationInfoCard(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            address: locationManager.address
                        )
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .padding()
                    }
                }
            }
            .navigationTitle("Konum Takip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFavorites = true
                    } label: {
                        Label("Favoriler", systemImage: "star.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if let location = locationManager.location {
                        Button {
                            withAnimation {
                                cameraPosition = .camera(
                                    MapCamera(
                                        centerCoordinate: location.coordinate,
                                        distance: 1000,
                                        heading: 0,
                                        pitch: 0
                                    )
                                )
                            }
                        } label: {
                            Label("Konumuma Git", systemImage: "location.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddLocationSheet(
                    coordinate: selectedCoordinate ?? CLLocationCoordinate2D(),
                    name: $newLocationName,
                    address: $newLocationAddress,
                    isGeocoding: $isGeocodingNewLocation,
                    onSave: saveLocation,
                    onCancel: {
                        showingAddSheet = false
                        selectedCoordinate = nil
                        newLocationName = ""
                        newLocationAddress = ""
                    }
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showFavorites) {
                FavoritesView()
            }
        }
        .task {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            } else if locationManager.authorizationStatus == .authorizedWhenInUse ||
                      locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startTracking()
            }
        }
        .onAppear {
            if let location = locationManager.location {
                cameraPosition = .camera(
                    MapCamera(
                        centerCoordinate: location.coordinate,
                        distance: 1000
                    )
                )
            }
        }
    }
    
    private func handleMapTap(at point: CGPoint) {
        // Ekran koordinatından coğrafi koordinata dönüşüm yapmak için
        // MapProxy kullanmamız gerekiyor, ancak bu daha karmaşık
        // Bunun yerine, kullanıcıdan favorilere eklemek için mevcut konumunu kullanmasını isteyeceğiz
        
        // Şu an için basit bir yaklaşım: kamera merkezini kullan
        print("Haritaya uzun basıldı: \(point)")
        
        // Kullanıcıya bilgi ver
        showAddLocationAlert()
    }
    
    private func showAddLocationAlert() {
        // Kullanıcıya mevcut kamera konumunu kaydetmesini öner
        guard let location = locationManager.location else { return }
        
        selectedCoordinate = location.coordinate
        newLocationAddress = locationManager.address
        showingAddSheet = true
    }
    
    private func saveLocation() {
        guard let coordinate = selectedCoordinate else { return }
        
        let favorite = FavoriteLocation(
            name: newLocationName.isEmpty ? "Kaydedilmemiş Konum" : newLocationName,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            address: newLocationAddress
        )
        
        modelContext.insert(favorite)
        
        // Reset
        showingAddSheet = false
        selectedCoordinate = nil
        newLocationName = ""
        newLocationAddress = ""
    }
}

struct LocationInfoCard: View {
    let latitude: Double
    let longitude: Double
    let address: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mevcut Konum")
                        .font(.headline)
                    
                    Text(address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enlem")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.6f", latitude))
                        .font(.system(.body, design: .monospaced))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Boylam")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.6f", longitude))
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .padding()
    }
}

struct AddLocationSheet: View {
    let coordinate: CLLocationCoordinate2D
    @Binding var name: String
    @Binding var address: String
    @Binding var isGeocoding: Bool
    let onSave: () -> Void
    let onCancel: () -> Void
    
    @State private var geocoder = CLGeocoder()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Konum Bilgileri") {
                    TextField("Konum Adı", text: $name)
                    
                    if isGeocoding {
                        HStack {
                            ProgressView()
                            Text("Adres alınıyor...")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text(address)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Koordinatlar") {
                    LabeledContent("Enlem", value: String(format: "%.6f", coordinate.latitude))
                    LabeledContent("Boylam", value: String(format: "%.6f", coordinate.longitude))
                }
            }
            .navigationTitle("Favori Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal", action: onCancel)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: onSave)
                        .disabled(name.isEmpty)
                }
            }
            .task {
                await reverseGeocode()
            }
        }
    }
    
    private func reverseGeocode() async {
        isGeocoding = true
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                var addressComponents: [String] = []
                
                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                if let subLocality = placemark.subLocality {
                    addressComponents.append(subLocality)
                }
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                if let country = placemark.country {
                    addressComponents.append(country)
                }
                
                address = addressComponents.isEmpty ? "Adres bulunamadı" : addressComponents.joined(separator: ", ")
            }
        } catch {
            address = "Adres alınamadı"
            print("Geocoding error: \(error.localizedDescription)")
        }
        
        isGeocoding = false
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteLocation.self, inMemory: true)
}
