import SwiftUI

struct EventListView: View {
    @StateObject private var vm = EventListViewModel()
    @State private var isPresentingAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                if vm.events.isEmpty {
                    ContentUnavailableView("Henüz etkinlik yok",
                                           systemImage: "calendar.badge.plus",
                                           description: Text("Sağ üstten + ile yeni etkinlik ekleyin."))
                } else {
                    ForEach(vm.events) { event in
                        NavigationLink(value: event.id) {
                            EventRow(event: event)
                        }
                        .accessibilityLabel("\(event.type.rawValue) etkinliği: \(event.title)")
                        .accessibilityHint(event.date.formatted(.dateTime.day().month().year().hour().minute()))
                    }
                    .onDelete(perform: vm.delete)
                }
            }
            .navigationTitle("Etkinlikler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni Etkinlik Ekle")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isPresentingAdd) {
                AddEventView { input in
                    vm.addEvent(title: input.title, date: input.date, type: input.type, hasReminder: input.hasReminder)
                }
                .presentationDetents([.large])
            }
            .navigationDestination(for: UUID.self) { id in
                EventDetailView(vm: vm, eventID: id)
            }
            .task {
                // Demo için veri
                if vm.events.isEmpty { vm.seed() }
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 12) {
            Text(event.type.icon)
                .font(.title2)
                .frame(width: 34, height: 34)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if event.hasReminder {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("Hatırlatıcı açık")
            }
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    EventListView()
}
