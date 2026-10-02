import SwiftUI

/// The default calendar builders exposed as a concrete convenience view.
public struct DefaultCalendarView: View {
    @Binding private var date: Date
    @Binding private var selection: TimeRange?
    private let type: CalendarType
    private let colorSet: any CalendarColorSet
    private let calendar: Calendar
    private let contentColorIndicator: (Date) -> Color?
    private var isMultiselectionEnabled = true
    private var isSelectionEnabled = true

    public init(date: Binding<Date>, selection: Binding<TimeRange?> = .constant(nil),
                calendar: Calendar = .current, type: CalendarType = .monthly,
                colorSet: any CalendarColorSet = DefaultCalendarColorSet(),
                contentColorIndicator: @escaping (Date) -> Color? = { _ in nil }) {
        self._date = date
        self._selection = selection
        self.type = type
        self.colorSet = colorSet
        self.calendar = calendar
        self.contentColorIndicator = contentColorIndicator
    }

    public var body: some View {
        CalendarView(date: $date, selection: $selection, calendar: calendar, type: type,
                     colorSet: colorSet, contentColorIndicator: contentColorIndicator)
            .multiselectionEnabled(isMultiselectionEnabled)
            .selectionEnabled(isSelectionEnabled)
    }

    public func multiselectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isMultiselectionEnabled = enabled
        return view
    }

    public func selectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isSelectionEnabled = enabled
        return view
    }
}
