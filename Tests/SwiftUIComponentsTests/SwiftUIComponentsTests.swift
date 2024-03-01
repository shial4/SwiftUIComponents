import XCTest
@testable import SwiftUIComponents

final class SwiftUIComponentsTests: XCTestCase {
    func testCalendarViewBasicInit() throws {
        XCTAssertNotNil(CalendarView(date: .constant(Date()), colorSet: DefaultCalendarColorSet()))
    }
}
