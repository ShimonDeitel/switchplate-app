import XCTest
@testable import Switchplate

@MainActor
final class SwitchplateTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntryIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(PlateEntry(room: "Test", plateColor: "Today", dateInstalled: "Good"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = Store()
        store.isPro = false
        while store.entries.count < Store.freeLimit {
            store.add(PlateEntry(room: "X", plateColor: "Y", dateInstalled: "Z"))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        let store = Store()
        store.isPro = true
        while store.entries.count < Store.freeLimit {
            store.add(PlateEntry(room: "X", plateColor: "Y", dateInstalled: "Z"))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        let entry = PlateEntry(room: "ToDelete", plateColor: "Today", dateInstalled: "Good")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testUpdateModifiesEntry() {
        let store = Store()
        var entry = PlateEntry(room: "Orig", plateColor: "Today", dateInstalled: "Good")
        store.add(entry)
        entry.room = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.room, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = Store()
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }
}
