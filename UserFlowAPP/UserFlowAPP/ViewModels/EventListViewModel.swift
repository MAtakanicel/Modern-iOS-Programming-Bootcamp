import SwiftUI
import Combine

final class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    //CRUD
    func addEvent(title: String, date: Date, type: EventType, hasReminder: Bool) {
        let new = Event(title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        date: date,
                        type: type,
                        hasReminder: hasReminder)
        events.append(new)
        sortByDate()
    }
    
    func delete(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
    
    func delete(id: UUID) {
        events.removeAll { $0.id == id }
    }
    
    func toggleReminder(for id: UUID) {
        guard let idx = events.firstIndex(where: { $0.id == id }) else { return }
        events[idx].hasReminder.toggle()
    }
    
    func update(id: UUID, title: String? = nil, date: Date? = nil, type: EventType? = nil, hasReminder: Bool? = nil) {
        guard let idx = events.firstIndex(where: { $0.id == id }) else { return }
        if let title { events[idx].title = title }
        if let date { events[idx].date = date }
        if let type { events[idx].type = type }
        if let hasReminder { events[idx].hasReminder = hasReminder }
        sortByDate()
    }
    
    // Helpers
    func index(of id: UUID) -> Int? {
        events.firstIndex(where: { $0.id == id })
    }
    
    private func sortByDate() {
        events.sort { $0.date < $1.date }
    }
    
    // Demo verisi
    func seed() {
        events = [
            Event(title: "Atakan'ın Doğum Günü", date: .now.addingTimeInterval(60*60*24*2), type: .dogumGunu, hasReminder: true),
            Event(title: "Şirket Toplantısı",       date: .now.addingTimeInterval(60*60*24*5), type: .toplantı),
            Event(title: "Tatil",           date: .now.addingTimeInterval(60*60*24*12), type: .tatil),
            Event(title: "Maraton Koşusu",         date: .now.addingTimeInterval(60*60*24*1), type: .spor)
        ]
        sortByDate()
    }
}
