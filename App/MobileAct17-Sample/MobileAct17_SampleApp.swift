import SwiftUI
import SwiftData

@main
struct MobileAct17_SampleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ListWithMacroView()
                        .modelContainer(for: TodoModel.self)
                }
                .tabItem {
                    Label("Queryマクロあり", systemImage: "swiftdata")
                }

                NavigationStack {
                    ListWithoutMacroView(
                        viewModel: .init(
                            todoStore: TodoStore(
                                todoRepository: TodoRepository(
                                    swiftDataClient: SwiftDataClient.liveValue
                                )
                            )
                        )
                    )
                }
                .tabItem {
                    Label("Queryマクロなし", systemImage: "swiftdata")
                }
            }
        }
    }
}
