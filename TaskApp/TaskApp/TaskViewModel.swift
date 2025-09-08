import Foundation
import Combine

@MainActor
final class TaskViewModel: ObservableObject {
    // UI'yı tetikleyen kaynak veri
    @Published private(set) var tasks: [Task] = [] {
        didSet { persistIfNeeded() }
    }

    // İsteğe bağlı kalıcılık anahtarı
    private let storageKey = "TASKS_STORAGE_V1"
    private let enablePersistence: Bool

    init(enablePersistence: Bool = true) {
        self.enablePersistence = enablePersistence
        if enablePersistence { loadFromStorage() }
    }

    // Bölümlere ayrılmış görünümler için türetilmiş listeler
    var pendingTasks: [Task] { tasks.filter { !$0.isCompleted } }
    var completedTasks: [Task] { tasks.filter { $0.isCompleted } }

    // MARK: - Intentler
    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        tasks.insert(Task(title: trimmed), at: 0) // Yeni en üste
    }

    func toggleCompletion(for taskID: UUID) {
        guard let idx = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[idx].isCompleted.toggle()
    }

    func deleteTasks(with ids: [UUID]) {
        guard ids.isEmpty == false else { return }
        let idSet = Set(ids)
        tasks.removeAll { idSet.contains($0.id) }
    }

    func clearCompleted() {
        tasks.removeAll { $0.isCompleted }
    }

    // MARK: - Persistence (opsiyonel)
    private func persistIfNeeded() {
        guard enablePersistence else { return }
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Prod’da: logging
            print("Persist error:", error)
        }
    }

    private func loadFromStorage() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([Task].self, from: data)
        else { return }
        self.tasks = decoded
    }
}
