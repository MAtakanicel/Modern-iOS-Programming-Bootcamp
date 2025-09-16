import SwiftUI

struct AddNoteView: View {
    @ObservedObject var noteManager: NoteManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Başlık
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Başlık")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    TextField("Not başlığını girin...", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTitleFocused)
                }
                .padding()
                .background(Color(.systemGray6))
                
                // İçerik
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("İçerik")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    TextEditor(text: $content)
                        .font(.body)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Yeni Not")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveNote()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
                             content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedTitle.isEmpty || !trimmedContent.isEmpty {
            noteManager.addNote(title: trimmedTitle, content: trimmedContent)
            dismiss()
        }
    }
}

#Preview {
    AddNoteView(noteManager: NoteManager())
}
