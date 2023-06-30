# SwiftUIComponents

[![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

SwiftUIComponents is a collection of additional shapes, modifiers, and views for SwiftUI and compatible frameworks. It aims to enhance your SwiftUI development experience by providing a variety of reusable components.

## Features

- [Additional shapes](Sources/SwiftUIComponents/Components/Shapes/): Discover a collection of custom shapes that you can use in your SwiftUI projects.
- [Modifiers](Sources/SwiftUIComponents/Components/ViewModifiers/): Extend the functionality of SwiftUI views with a set of useful modifiers.
- [Custom views](Sources/SwiftUIComponents/Components/): Access a range of pre-built views that can be easily integrated into your SwiftUI layouts.
- [Examples](Examples): Explore various examples and use cases to see the components in action.

## Installation

SwiftUIComponents is available as a Swift Package and can be easily integrated into your projects. Simply add the package repository URL to your Xcode project or use the Swift Package Manager.

1. In Xcode, select your project or workspace.
2. Go to the "Swift Packages" tab.
3. Click the "+" button to add a new package.
4. Enter the repository URL: `https://github.com/shial4/SwiftUIComponents.git`
5. Choose the desired version or branch.
6. Click "Next" and follow the prompts to complete the integration.

## Usage

Once you have integrated SwiftUIComponents into your project, you can start using the additional shapes, modifiers, and views provided by the package. Import the module in your code and begin leveraging the components in your SwiftUI views.

```swift
import SwiftUIComponents

struct ContentView: View {
    @State var currentDate = Date()
    @State var selectedDates: ClosedRange<Date>? = nil
    
    let calendar: Calendar = Calendar.current
    
    var body: some View {
        CalendarView(date: $currentDate, selection: $selectedDates, calendar: calendar)
    }
}
```

## Examples

To see SwiftUIComponents in action and explore different use cases, check out the examples provided in the `Examples/ViewExamples` directory of this repository. Each example demonstrates how to use specific components and showcases their capabilities.

## Preview

<video width="296" height="640" controls>
  <source src="Resources/preview.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Documentation

Comprehensive documentation for SwiftUIComponents can be found in the `Docs` directory of this repository. It provides detailed information about each component, including usage instructions, available modifiers, and examples.

## Supported Platforms

SwiftUIComponents supports the following platforms and their respective minimum versions:

- macOS (version 13 and above)
- iOS (version 16 and above)
- [Tokamak](https://github.com/TokamakUI/Tokamak) (hopefully soon)

## Contributing

Contributions to SwiftUIComponents are welcome! If you find a bug, have a feature request, or want to contribute improvements or new components, please open an issue or submit a pull request. Make sure to follow the contribution guidelines outlined in the repository.

## Acknowledgments

- Thanks to the [Antoine van der Lee](https://www.avanderlee.com/swiftui/conditional-view-modifier/) for blog on "Creating a Conditional View Modifier extension"
- Thanks to the [fivestars blog](https://www.fivestars.blog/articles/reverse-masks-how-to/) for article on "How to apply a reverse mask in SwiftUI"
- Thanks to the [kontiki](https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui/56763282#56763282) for Custom RoundedCorners Shape

SwiftUI is a trademark owned by Apple Inc. Software maintained as a part of this  project is not affiliated with Apple Inc.

## License

SwiftUIComponents is released under the MIT License. See the [LICENSE](LICENSE) file for details.
