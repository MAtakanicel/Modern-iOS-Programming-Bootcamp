import Foundation

enum EventType: String, CaseIterable, Identifiable, Codable {
    case dogumGunu = "Doğum Günü"
    case toplantı   = "Toplantı"
    case tatil      = "Tatil"
    case spor       = "Spor"
    case diger      = "Diğer"
    
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .dogumGunu: return "🎂"
        case .toplantı:  return "📊"
        case .tatil:     return "🏖️"
        case .spor:      return "🏅"
        case .diger:     return "📌"
        }
    }
}

struct Event: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var type: EventType
    var hasReminder: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        type: EventType,
        hasReminder: Bool = false
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.hasReminder = hasReminder
    }
}
