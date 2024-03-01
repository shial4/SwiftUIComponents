//
//  ContentView.swift
//  Examples
//
//  Created by Szymon on 30/6/2023.
//

import SwiftUI

struct ContentView: View {
    private enum NavigationDestinations {
        case calendar, progress, checkbox, rating, badge, slider, labels
    }
    
    var body: some View {
        NavigationView {
            List {
                listElement(label: "Calendar", destination: .calendar)
                listElement(label: "Progress", destination: .progress)
                listElement(label: "Sliders", destination: .slider)
                listElement(label: "Checkbox", destination: .checkbox)
                listElement(label: "Rating", destination: .rating)
                listElement(label: "Badges", destination: .badge)
                listElement(label: "Labels", destination: .labels)
            }
        }
    }

    private func listElement(label: String, destination: NavigationDestinations) -> some View {
        NavigationLink {
            if destination == .calendar {
                CalendarExampleView()
            } else if destination == .checkbox {
                CheckboxExampleView()
            } else if destination == .rating {
                RatingExampleView()
            } else if destination == .badge {
                BadgeExampleView()
            } else if destination == .progress {
                ProgressExampleView()
            } else if destination == .slider {
                SliderExampleView()
            } else if destination == .labels {
                LabelExampleView()
            } else {
                Text("Nothing here")
            }
        } label: {
            HStack {
                Text(label)
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
