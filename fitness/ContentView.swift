import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentWorkoutView()
                .tabItem {
                    Label("Current Workout", systemImage: "figure.strengthtraining.traditional")
                }
            
            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
            
            ExerciseLibraryView()
                .tabItem {
                    Label("Exercises", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
