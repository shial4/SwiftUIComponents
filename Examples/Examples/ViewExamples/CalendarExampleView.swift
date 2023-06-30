import SwiftUI
import SwiftUIComponents

struct CalendarExampleView: View {
    @State var currentDate = Date()
    @State var selectedDates: ClosedRange<Date>? = nil
    
    let calendar: Calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height: 44)
                    CalendarView(date: $currentDate, selection: $selectedDates, calendar: calendar, type: .weekly)
                    CalendarView(date: $currentDate, selection: $selectedDates, calendar: calendar)
                    CalendarView(date: $currentDate, selection: $selectedDates, calendar: calendar, type: .yearly(3))
                    Spacer()
                        .frame(height: 44)
                    CalendarView(date: $currentDate)
                        .dayView { date, calendar, isDateInMonth, isSelected in
                            Text(date.formatted())
                        }
                }
            }
        }
    }
}

struct CalendarExampleView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarExampleView()
    }
}
