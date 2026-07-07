import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [PlateEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Switchplate", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            seed()
        }
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: PlateEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PlateEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PlateEntry) {
        entries.removeAll(where: { $0.id == entry.id })
        save()
    }

    private func seed() {
        entries = [
            PlateEntry(room: "Front", plateColor: "Recently checked", dateInstalled: "Good", notes: "Seed entry"),
            PlateEntry(room: "Back", plateColor: "Last month", dateInstalled: "Needs attention", notes: "Seed entry"),
            PlateEntry(room: "Side", plateColor: "Two months ago", dateInstalled: "Good", notes: "Seed entry"),
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([PlateEntry].self, from: data) else { return }
        entries = decoded
    }
}
