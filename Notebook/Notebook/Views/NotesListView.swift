
import SwiftUI

struct NotesListView: View {
    @StateObject private var noteManager = NoteManager()
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if noteManager.notes.isEmpty {
                    // Boş durum görseli
                    VStack(spacing: 20) {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("Henüz not bulunmuyor")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Yeni not eklemek için + butonuna dokunun")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(noteManager.notes) { note in
                            NoteRowView(note: note)
                                .onTapGesture {
                                    selectedNote = note
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("Sil", role: .destructive) {
                                        withAnimation {
                                            noteManager.deleteNote(note)
                                        }
                                    }
                                }
                        }
                        .onDelete(perform: deleteNotes)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 8)
                }
            }
            .navigationTitle("Notlarım")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddNote = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(noteManager: noteManager)
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note, noteManager: noteManager)
            }
        }
    }
    
    func deleteNotes(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                noteManager.deleteNote(noteManager.notes[index])
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.title.isEmpty ? "Başlıksız Not" : note.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Spacer()
                
                Text(note.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(CustomBackground())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    NotesListView()
}
