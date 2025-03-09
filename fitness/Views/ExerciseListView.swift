import SwiftUI
import SwiftData

struct ExerciseListView: View {
    let session: WorkoutSession
    let groupedExercises: [Exercise]
    let addSet: (Exercise) -> Void
    let setsForExercise: (Exercise) -> [WorkoutSet]
    let formatRestTime: (Int) -> String
    
    var body: some View {
        List {
            ForEach(groupedExercises, id: \.id) { exercise in
                Section(exercise.name) {
                    ForEach(setsForExercise(exercise)) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                            
                            Spacer()
                            
                            if set.exercise?.isBodyweightExercise == true {
                                Text("Bodyweight")
                            } else {
                                TextField("Weight", value: Binding(
                                    get: { set.weight ?? 0 },
                                    set: { set.weight = $0 }
                                ), formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                            }
                            
                            if let restTime = set.restTimeSeconds {
                                Text("Rest: \(formatRestTime(restTime))")
                            }
                        }
                    }
                    
                    // Add set button
                    Button(action: {
                        addSet(exercise)
                    }) {
                        Label("Add Set", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ExerciseListView(
        session: WorkoutSession(),
        groupedExercises: [],
        addSet: { _ in },
        setsForExercise: { _ in [] },
        formatRestTime: { _ in "" }
    )
    .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
