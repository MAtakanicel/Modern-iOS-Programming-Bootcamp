import SwiftUI

struct AddEventInput {
    var title: String = ""
    var date: Date = .now
    var type: EventType = .diger
    var hasReminder: Bool = false
}

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var input = AddEventInput()
    @State private var showValidation = false
    
    let onSave: (AddEventInput) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Etkinlik Bilgileri") {
                    TextField("Etkinlik adı", text: $input.title)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)
                    
                    DatePicker("Tarih", selection: $input.date, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Tür", selection: $input.type) {
                        ForEach(EventType.allCases) { t in
                            Text("\(t.icon)  \(t.rawValue)").tag(t)
                        }
                    }
                    
                    Toggle("Hatırlatıcı", isOn: $input.hasReminder)
                }
            }
            .navigationTitle("Yeni Etkinlik")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        if input.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showValidation = true
                        } else {
                            onSave(input)
                            dismiss()
                        }
                    }
                }
            }
            .alert("Başlık boş olamaz", isPresented: $showValidation) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Lütfen etkinlik adı giriniz.")
            }
        }
    }
}


