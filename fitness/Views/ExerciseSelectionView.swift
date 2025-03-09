import SwiftUI
import SwiftData

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [Exercise]
    let onSelect: (Exercise) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) { exercise in
                    Button(action: {
                        onSelect(exercise)
                        dismiss()
                    }) {
                        Text(exercise.name)
                    }
                }
            }
            .navigationTitle("Select Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ExerciseSelectionView(onSelect: { _ in })
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
