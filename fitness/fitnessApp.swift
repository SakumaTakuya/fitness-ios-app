import SwiftUI
import SwiftData

@main
struct FitnessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self])
    }
}
