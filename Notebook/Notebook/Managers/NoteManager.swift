import Foundation

class NoteManager: ObservableObject {
    private let notesKey = "SavedNotes"
    @Published var notes: [Note] = []
    
    init() {
        loadNotes()
    }
    
    // UserDefaults verileri
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey) {
            do {
                let decoder = JSONDecoder()
                notes = try decoder.decode([Note].self, from: data)
                notes.sort { $0.date > $1.date }
            } catch {
                print("Not yüklenirken hata oluştu: \(error.localizedDescription)")
                notes = []
            }
        }
    }
    
    // Notları UserDefaults'a kaydetme
    func saveNotes() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            UserDefaults.standard.set(data, forKey: notesKey)
        } catch {
            print("Notlar kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // Yeni not
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.insert(newNote, at: 0)
        saveNotes()
    }
    
    // Not silme
    func deleteNote(_ note: Note) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
            saveNotes()
        }
    }
    
    // Not güncelleme
    func updateNote(_ note: Note, title: String, content: String) {
        if let index = notes.firstIndex(of: note) {
            let updatedNote = Note(title: title, content: content)
            notes[index] = updatedNote
            notes.sort { $0.date > $1.date }
            saveNotes()
        }
    }
    
    // Arama
    func getNote(by id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
}
