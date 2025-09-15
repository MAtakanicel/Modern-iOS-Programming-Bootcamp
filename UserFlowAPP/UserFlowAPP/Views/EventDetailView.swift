import SwiftUI

struct EventDetailView: View {
    @ObservedObject var vm: EventListViewModel
    let eventID: UUID
    @Environment(\.dismiss) private var dismiss
    @State private var confirmDelete = false
    
    var body: some View {
        if let idx = vm.index(of: eventID) {
            let binding = $vm.events[idx]
            Form {
                Section("Genel") {
                    TextField("Başlık", text: binding.title)
                    DatePicker("Tarih", selection: binding.date, displayedComponents: [.date, .hourAndMinute])
                    Picker("Tür", selection: binding.type) {
                        ForEach(EventType.allCases) { t in
                            Text("\(t.icon)  \(t.rawValue)").tag(t)
                        }
                    }
                    Toggle("Hatırlatıcı", isOn: binding.hasReminder)
                }
                
                Section {
                    Button(role: .destructive) {
                        confirmDelete = true
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Etkinlik Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Etkinlik silinsin mi?",
                                isPresented: $confirmDelete,
                                titleVisibility: .visible) {
                Button("Sil", role: .destructive) {
                    vm.delete(id: eventID)
                    dismiss()
                }
                Button("Vazgeç", role: .cancel) { }
            }
        } else {
            ContentUnavailableView("Etkinlik bulunamadı",
                                   systemImage: "exclamationmark.triangle",
                                   description: Text("Kayıt silinmiş veya taşınmış olabilir."))
        }
    }
}
