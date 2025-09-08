
import SwiftUI

// MARK: - Model
struct MasterItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var detail: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, detail: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.detail = detail
        self.isCompleted = isCompleted
    }
}

// MARK: - ViewModel
final class MasterListViewModel: ObservableObject {
    @Published var items: [MasterItem] = []

    init() {
        // 10 öğe
        items = (1...10).map { idx in
            MasterItem(title: "Öğe #\(idx)", detail: "Bu, örnek açıklama metnidir (\(idx)).")
        }
    }

    var pending: [MasterItem] { items.filter { !$0.isCompleted } }
    var done: [MasterItem] { items.filter { $0.isCompleted } }

    func add(title: String, detail: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let newItem = MasterItem(title: title, detail: detail)
        items.insert(newItem, at: 0)
    }

    func delete(_ indexSet: IndexSet, inCompletedSection: Bool) {
        let source = inCompletedSection ? pending : done
        let idsToDelete = indexSet.map { source[$0].id }
        items.removeAll { idsToDelete.contains($0.id) }
    }

    func toggleCompletion(_ item: MasterItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx].isCompleted.toggle()
    }
}

// MARK: - Tema
struct Theme {
    let tint: Color
    let background: LinearGradient

    static func random() -> Theme {
        let palettes: [(Color, [Color])] = [
            (.indigo, [.indigo.opacity(0.3), .blue.opacity(0.1)]),
            (.teal, [.teal.opacity(0.3), .green.opacity(0.1)]),
            (.orange, [.orange.opacity(0.3), .yellow.opacity(0.1)]),
            (.pink, [.pink.opacity(0.3), .purple.opacity(0.1)]),
            (.mint, [.mint.opacity(0.4), .cyan.opacity(0.1)])
        ]
        let pick = palettes.randomElement()!
        return Theme(
            tint: pick.0,
            background: LinearGradient(colors: pick.1, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}

// MARK: - Detay Görünümü
struct DetailView: View {
    let item: MasterItem

    private let symbols = [
        "star.fill", "bolt.fill", "heart.text.square", "wand.and.rays", "paperplane.fill",
        "flame.fill", "hare.fill", "tortoise.fill", "leaf.fill", "bell.badge.fill"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: symbols.randomElement() ?? "star")
                .font(.system(size: 72, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.title2).bold()
                Text(item.detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding()
        .navigationTitle("Detay")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Ana Görünüm
struct ContentView: View {
    @StateObject private var vm = MasterListViewModel()
    @State private var showAdd = false
    @State private var useAlternativeLayout = false
    @State private var theme: Theme = .random()

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                Group {
                    if useAlternativeLayout {
                        alternativeLayout
                    } else {
                        listLayout
                    }
                }
                .animation(.snappy, value: useAlternativeLayout)
            }
            .navigationTitle("MasterListApp")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Picker("Görünüm", selection: $useAlternativeLayout) {
                        Text("List").tag(false)
                        Text("LazyVStack").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 260)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Label("Yeni Öğe", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addItemButton")
                }
            }
            .tint(theme.tint)
            .sheet(isPresented: $showAdd) {
                AddItemSheet { title, detail in
                    vm.add(title: title, detail: detail)
                }
                .tint(theme.tint)
            }
            .onAppear {
                // Rastgele tema uygula (challenge)
                theme = .random()
            }
        }
    }

    // MARK: List Düzeni (Sections + swipe)
    private var listLayout: some View {
        List {
            Section("Tamamlanacaklar") {
                ForEach(vm.pending) { item in
                    NavigationLink(value: item) {
                        row(item)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) { vm.delete(IndexSet(integer: vm.pending.firstIndex(of: item)!), inCompletedSection: true) } label: {
                            Label("Sil", systemImage: "trash")
                        }
                        Button { vm.toggleCompletion(item) } label: {
                            Label("Tamamla", systemImage: "checkmark.circle")
                        }
                    }
                }
                .onDelete { indexSet in
                    vm.delete(indexSet, inCompletedSection: true)
                }
            }

            Section("Tamamlananlar") {
                ForEach(vm.done) { item in
                    NavigationLink(value: item) {
                        row(item)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) { vm.delete(IndexSet(integer: vm.done.firstIndex(of: item)!), inCompletedSection: false) } label: {
                            Label("Sil", systemImage: "trash")
                        }
                        Button { vm.toggleCompletion(item) } label: {
                            Label("Geri Al", systemImage: "arrow.uturn.backward.circle")
                        }
                    }
                }
                .onDelete { indexSet in
                    vm.delete(indexSet, inCompletedSection: false)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationDestination(for: MasterItem.self) { item in
            DetailView(item: item)
        }
    }

    // MARK: Alternatif Düzen (ScrollView + LazyVStack)
    private var alternativeLayout: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tamamlanacaklar").font(.headline)
                LazyVStack(spacing: 8) {
                    ForEach(vm.pending) { item in
                        NavigationLink(value: item) {
                            card(item)
                        }
                    }
                }

                Text("Tamamlananlar").font(.headline).padding(.top, 8)
                LazyVStack(spacing: 8) {
                    ForEach(vm.done) { item in
                        NavigationLink(value: item) {
                            card(item)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationDestination(for: MasterItem.self) { item in
            DetailView(item: item)
        }
    }

    // MARK: Hücre görünümleri
    private func row(_ item: MasterItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title).font(.body.weight(.semibold))
                Text(item.detail).font(.callout).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }

    private func card(_ item: MasterItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.tint.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: item.isCompleted ? "checkmark.seal.fill" : "square.and.pencil")
                        .imageScale(.large)
                        .foregroundStyle(theme.tint)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline)
                Text(item.detail).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Yeni Öğe Ekleme Sheet'i
struct AddItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var detail: String = ""

    var onAdd: (String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Başlık") {
                    TextField("Örn: Yeni görev", text: $title)
                        .textInputAutocapitalization(.sentences)
                }
                Section("Açıklama") {
                    TextField("Kısa açıklama", text: $detail, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Yeni Öğe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ekle") {
                        onAdd(title, detail)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddItemSheet(onAdd: { _, _ in })
}
