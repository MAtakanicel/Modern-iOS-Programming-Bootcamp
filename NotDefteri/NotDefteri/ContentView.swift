import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.date, ascending: false)],
        animation: .default)
    private var notes: FetchedResults<Note>

    @State private var showingEditor = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { note in
                    NavigationLink(destination: NoteEditorView(note: note)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title)
                                .font(.headline)
                                .lineLimit(1)
                            Text(note.date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notlar")
            .searchable(text: $searchText, placement: .automatic, prompt: "Notlarda ara")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditor = true }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni Not Ekle")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingEditor) {
                NavigationStack {
                    NoteEditorView()
                }
            }
        }
    }

    private var filteredNotes: [Note] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard keyword.isEmpty == false else { return Array(notes) }
        return notes.filter { $0.title.localizedCaseInsensitiveContains(keyword) }
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            let note = notes[index]
            viewContext.delete(note)
        }
        do {
            try viewContext.save()
        } catch {
            print("Silme hatası: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
