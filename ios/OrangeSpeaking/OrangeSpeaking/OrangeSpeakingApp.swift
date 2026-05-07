import SwiftUI

@main
struct OrangeSpeakingApp: App {
    @StateObject private var viewModel = LessonViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onOpenURL { url in
                    viewModel.openDeepLink(url)
                }
        }
    }
}
