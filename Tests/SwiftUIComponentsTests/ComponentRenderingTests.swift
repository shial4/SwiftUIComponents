#if !os(Android)
import SwiftUI
import Testing
@testable import SwiftUIComponents

extension HostedRenderingTests {
    @Test("Rating fill preserves fractional stars at normal and compact sizes",
          arguments: [0.0, 0.25, 0.5, 2.5, 4.75, 5.0])
    func ratingFill(rating: Double) throws {
        for width in [50.0, 240.0] {
            let spacing = 8.0
            let side = min(48, (width - spacing * 4) / 5)
            let actual = RatingView(rating: .constant(rating), spacing: spacing)
                .frame(width: width, height: 48)
            let reference = HStack(spacing: spacing) {
                ForEach(0..<5) { index in
                    Star().stroke(.foreground)
                        .overlay {
                            Star().fill(.foreground)
                                .mask(alignment: .leading) {
                                    Rectangle().frame(width: side * min(1, max(0, rating - Double(index))))
                                }
                        }
                        .frame(width: side, height: side)
                }
            }.frame(width: width, height: 48)
            let rendered = try pixels(actual)
            let expected = try pixels(reference)
            #expect(rendered.count == expected.count)
            // Allow antialiasing at the intersection of the star and fractional edge.
            let difference = zip(rendered, expected).reduce(0) { $0 + abs(Int($1.0) - Int($1.1)) }
            #expect(Double(difference) / Double(expected.count) < 2)
        }
    }

    @Test("Reverse masks keep translated cutouts and requested alignment",
          arguments: [-35.0, 0.0, 35.0])
    func movingMask(offset: Double) throws {
        for alignment in [Alignment.leading, .center, .trailing] {
            let image = try pixels(Rectangle()
                .reverseMask(alignment: alignment) {
                    Rectangle().frame(width: 20, height: 40).offset(x: offset)
                }
                .frame(width: 160, height: 80))
            let center = (alignment == .leading ? 10.0 : alignment == .trailing ? 150.0 : 80.0) + offset
            for x in 0..<160 {
                let cutout = abs(Double(x) + 0.5 - center) < 10
                #expect(image[(40 * 160 + x) * 4] == (cutout ? 255 : 0))
            }
        }
    }

    private func pixels(_ view: some View) throws -> [UInt8] {
        let renderer = ImageRenderer(content: view.foregroundStyle(.black).background(.white))
        renderer.scale = 1
        let image = try #require(renderer.cgImage)
        var bytes = [UInt8](repeating: 0, count: image.width * image.height * 4)
        try bytes.withUnsafeMutableBytes { buffer in
            let context = try #require(CGContext(data: buffer.baseAddress, width: image.width, height: image.height,
                bitsPerComponent: 8, bytesPerRow: image.width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        }
        return bytes
    }
}
#endif
