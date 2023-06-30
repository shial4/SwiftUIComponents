import SwiftUI
import SwiftUIComponents

struct ProgressExampleView: View {
    @State var progress: Double = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("\(Int(progress * 66))%")
                    .font(.title)
                    .bold()
                Progress(progress: $progress, content: Circle())
                    .frame(width: 66, height: 66)
                Progress(progress: $progress, content: Rectangle())
                    .frame(width: 66, height: 66)
                Progress(progress: $progress, content: Rectangle())
                    .frame(width: 66, height: 1)
                Progress(progress: $progress, content: Star())
                    .frame(width: 66, height: 66)
                Progress(progress: $progress, content: Arrow())
                    .frame(width: 66, height: 66)
                Progress(progress: $progress, content: Chevron())
                    .frame(width: 66, height: 66)
                Progress(progress: $progress, content: Tick())
                    .frame(width: 66, height: 66)
                Button("Increase Progress") {
                    withAnimation { 
                        progress += 0.1
                    }
                }
                Button("Reset Progress") {
                    progress = 0.0
                }
            }
            .background(.gray)
        }
        .padding()
    }
}

struct ProgressExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressExampleView()
    }
}
