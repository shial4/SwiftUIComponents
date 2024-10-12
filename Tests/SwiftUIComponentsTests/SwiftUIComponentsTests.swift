import XCTest
import SwiftUI
@testable import SwiftUIComponents

final class SwiftUIComponentsTests: XCTestCase {
    func testCalendarViewBasicInit() throws {
        XCTAssertNotNil(CalendarView(date: Binding.constant(Date()), colorSet: DefaultCalendarColorSet()))
    }
}
