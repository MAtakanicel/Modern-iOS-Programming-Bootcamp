import Foundation
import SwiftData
import CoreLocation

@Model
final class FavoriteLocation {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String
    var createdAt: Date
    
    init(name: String, latitude: Double, longitude: Double, address: String) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.createdAt = Date()
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

