import SwiftUI
import CoreData

struct NoteEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var note: Note?

    @State private var titleText: String = ""
    @State private var contentText: String = ""

    init(note: Note? = nil) {
        self.note = note
        _titleText = State(initialValue: note?.title ?? "")
        _contentText = State(initialValue: note?.content ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Başlık")) {
                    TextField("Not başlığı", text: $titleText)
                }
                Section(header: Text("İçerik")) {
                    TextEditor(text: $contentText)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle(note == nil ? "Yeni Not" : "Notu Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save)
                        .disabled(titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            if let note, titleText.isEmpty && contentText.isEmpty {
                titleText = note.title
                contentText = note.content
            }
        }
    }

    private func save() {
        if let note {
            note.title = titleText
            note.content = contentText
            note.date = Date()
        } else {
            _ = Note.create(in: viewContext, title: titleText, content: contentText)
        }
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Kaydetme hatası: \(error)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return NoteEditorView()
        .environment(\.managedObjectContext, context)
}


