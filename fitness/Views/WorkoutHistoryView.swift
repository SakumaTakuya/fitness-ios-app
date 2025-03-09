import SwiftUI
import SwiftData

struct WorkoutHistoryView: View {
    @Query private var sessions: [WorkoutSession]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions) { session in
                    NavigationLink(destination: WorkoutDetailView(session: session)) {
                        VStack(alignment: .leading) {
                            Text(session.formattedDate)
                                .font(.headline)
                            Text(exerciseNames(for: session))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Workout History")
    }

    private func exerciseNames(for session: WorkoutSession) -> String {
        let exercises = Set(session.sets.compactMap { $0.exercise?.name })
        return exercises.joined(separator: ", ")
    }
}

#Preview {
    WorkoutHistoryView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
