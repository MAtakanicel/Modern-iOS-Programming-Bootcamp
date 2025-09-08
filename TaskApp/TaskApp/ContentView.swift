import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TaskViewModel()
    @State private var newTitle: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Ekleme satırı
                HStack {
                    TextField("Yeni görev…", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit { add() }

                    Button {
                        add()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Görev Ekle")
                }
                .padding(.horizontal)

                // Liste
                ZStack {
                    CustomBackground()

                    List {
                        // Tamamlanacaklar
                        if !vm.pendingTasks.isEmpty {
                            Section("Tamamlanacaklar") {
                                ForEach(vm.pendingTasks) { task in
                                    TaskRow(task: task, onToggle: { vm.toggleCompletion(for: task.id) })
                                }
                                .onDelete { indexSet in
                                    let ids = indexSet.compactMap { vm.pendingTasks[$0].id }
                                    vm.deleteTasks(with: ids)
                                }
                            }
                        }

                        // Tamamlananlar
                        if !vm.completedTasks.isEmpty {
                            Section("Tamamlananlar") {
                                ForEach(vm.completedTasks) { task in
                                    TaskRow(task: task, onToggle: { vm.toggleCompletion(for: task.id) })
                                        .foregroundStyle(.secondary)
                                }
                                .onDelete { indexSet in
                                    let ids = indexSet.compactMap { vm.completedTasks[$0].id }
                                    vm.deleteTasks(with: ids)
                                }
                            }
                        }

                        // Boş durum
                        if vm.pendingTasks.isEmpty && vm.completedTasks.isEmpty {
                            ContentUnavailableView(
                                "Henüz görev yok",
                                systemImage: "checklist",
                                description: Text("Yukarıdan bir görev ekleyin.")
                            )
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
                
                .padding(.horizontal)
                .padding(.bottom, 8)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .navigationTitle("Görevler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tamamlananları Temizle", role: .destructive) {
                        vm.clearCompleted()
                    } .disabled(vm.completedTasks.isEmpty)
                }
            }
        }
    }

    private func add() {
        vm.addTask(title: newTitle)
        newTitle = ""
    }
}

// Tek satır görünümü
private struct TaskRow: View {
    let task: Task
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
            }
            .buttonStyle(.plain)

            if task.isCompleted {
                Text(task.title)
                    .strikethrough()
                    .foregroundStyle(.secondary)
            } else {
                Text(task.title)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(task.title))
        .accessibilityHint(Text(task.isCompleted ? "Tamamlandı, dokunarak geri al" : "Tamamlanmadı, dokunarak tamamla"))
    }
}

#Preview {
    ContentView()
}
