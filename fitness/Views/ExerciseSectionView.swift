import SwiftUI
import SwiftData

struct ExerciseSectionView: View {
    @Binding var newExerciseName: String
    @Binding var isBodyweightExercise: Bool
    @Binding var newWeight: String
    let filteredExercises: [Exercise]
    let addExercise: () -> Void
    let showingExerciseSelection: Binding<Bool>
    
    var body: some View {
        VStack {
            HStack {
                TextField("Add exercise", text: $newExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: {
                    showingExerciseSelection.wrappedValue = true
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            
            if !newExerciseName.isEmpty {
                List {
                    ForEach(filteredExercises, id: \.id) { exercise in
                        Button(action: {
                            newExerciseName = exercise.name
                            isBodyweightExercise = exercise.isBodyweightExercise
                        }) {
                            Text(exercise.name)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            
            Toggle("Bodyweight Exercise", isOn: $isBodyweightExercise)
            
            if !isBodyweightExercise {
                TextField("Weight (kg)", text: $newWeight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            
            Button(action: {
                addExercise()
            }) {
                Text("Add Exercise")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ExerciseSectionView(
        newExerciseName: .constant(""),
        isBodyweightExercise: .constant(false),
        newWeight: .constant(""),
        filteredExercises: [],
        addExercise: {},
        showingExerciseSelection: .constant(false)
    )
    .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
