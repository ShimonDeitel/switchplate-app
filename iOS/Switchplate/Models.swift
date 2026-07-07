import Foundation

struct PlateEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var room: String
    var plateColor: String
    var dateInstalled: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), room: String, plateColor: String, dateInstalled: String, notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.room = room
        self.plateColor = plateColor
        self.dateInstalled = dateInstalled
        self.notes = notes
        self.createdAt = createdAt
    }
}
