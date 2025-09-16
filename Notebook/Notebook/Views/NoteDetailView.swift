import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var noteManager: NoteManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var showingDeleteAlert = false
    
    init(note: Note, noteManager: NoteManager) {
        self.note = note
        self.noteManager = noteManager
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Tarih bilgisi
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                        Text(note.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if isEditing {
                        // Düzenleme
                        VStack(spacing: 16) {
                            // Başlık
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Başlık")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Başlık girin...", text: $editedTitle)
                                    .textFieldStyle(.plain)
                                    .padding(12)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(16)
                            .background(NoteDetailBackground())
                            
                            // İçerik
                            VStack(alignment: .leading, spacing: 12) {
                                Text("İçerik")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextEditor(text: $editedContent)
                                    .font(.body)
                                    .padding(12)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                                    .frame(minHeight: 200)
                            }
                            .padding(16)
                            .background(NoteDetailBackground())
                        }
                        .padding(.horizontal, 8)
                    } else {
                        // Görüntüleme
                        VStack(alignment: .leading, spacing: 16) {
                            // Sadece İçerik
                            VStack(alignment: .leading, spacing: 12) {
                                if !note.content.isEmpty {
                                    Text(note.content)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                } else {
                                    Text("Bu not boş görünüyor")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                            .background(NoteDetailBackground())
                            .padding(.horizontal, 8)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle(isEditing ? "Not Düzenle" : (note.title.isEmpty ? "Not Detayı" : note.title))
            .navigationBarTitleDisplayMode(isEditing ? .inline : .automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "İptal" : "Kapat") {
                        if isEditing {
                            editedTitle = note.title
                            editedContent = note.content
                            isEditing = false
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isEditing {
                            Button("Kaydet") {
                                saveChanges()
                            }
                            .disabled(editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
                                     editedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        } else {
                            Menu {
                                Button("Düzenle") {
                                    isEditing = true
                                }
                                
                                Button("Sil", role: .destructive) {
                                    showingDeleteAlert = true
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
                }
            }
            .alert("Not Sil", isPresented: $showingDeleteAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    deleteNote()
                }
            } message: {
                Text("Bu notu silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
            }
        }
    }
    
    private func saveChanges() {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = editedContent.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedTitle.isEmpty || !trimmedContent.isEmpty {
            noteManager.updateNote(note, title: trimmedTitle, content: trimmedContent)
            isEditing = false
        }
    }
    
    private func deleteNote() {
        noteManager.deleteNote(note)
        dismiss()
    }
}

#Preview {
    let sampleNote = Note(title: "Örnek Not", content: "Bu uygulama, SwiftUI Bootcamp programının 7. ödevi için geliştirilmiş bir uygulamadır. ")
    return NoteDetailView(note: sampleNote, noteManager: NoteManager())
}
