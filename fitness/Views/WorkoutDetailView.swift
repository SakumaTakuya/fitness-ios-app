import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    let session: WorkoutSession
    
    var body: some View {
        List {
            ForEach(groupedExercises(for: session), id: \.id) { exercise in
                Section(exercise.name) {
                    ForEach(setsForExercise(exercise, in: session)) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                            
                            Spacer()
                            
                            if let weight = set.weight {
                                Text("\(weight, specifier: "%.1f") kg")
                            } else {
                                Text("Bodyweight")
                            }
                            
                            if let restTime = set.restTimeSeconds {
                                Text("Rest: \(formatRestTime(restTime))")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(session.formattedDate)
    }
    
    private func formatRestTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }
    
    private func groupedExercises(for session: WorkoutSession) -> [Exercise] {
        let exercisesInSession = session.sets.compactMap { $0.exercise }
        return Array(Set(exercisesInSession)).sorted { $0.name < $1.name }
    }
    
    private func setsForExercise(_ exercise: Exercise, in session: WorkoutSession) -> [WorkoutSet] {
        return session.sets
            .filter { $0.exercise?.id == exercise.id }
            .sorted { $0.setNumber < $1.setNumber }
    }
}

#Preview {
    WorkoutDetailView(session: WorkoutSession())
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
