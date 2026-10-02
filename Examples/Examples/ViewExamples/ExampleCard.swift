import SwiftUI

/// A shared presentation surface for the executable examples.
struct ExampleCard<Content: View>: View {
    let title: String
    let detail: String
    @ViewBuilder let content: Content

    init(_ title: String, detail: String = "", @ViewBuilder content: () -> Content) {
        self.title = title
        self.detail = detail
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            if !detail.isEmpty { Text(detail).font(.callout).foregroundStyle(.secondary) }
            content.frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary.opacity(0.15), lineWidth: 1))
    }
}

struct ExampleCode: View {
    let code: String
    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.blue.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
    }
}
