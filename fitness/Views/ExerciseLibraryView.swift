import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    
    @State private var newExerciseName = ""
    @State private var showingAddExercise = false
    @State private var isBodyweightExercise = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) { exercise in
                    HStack {
                        Text(exercise.name)
                        
                        Spacer()
                        
                        if exercise.isBodyweightExercise {
                            Text("Bodyweight")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteExercise)
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addExercise()
                    }) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                VStack {
                    TextField("Exercise Name", text: $newExerciseName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Toggle("Bodyweight Exercise", isOn: $isBodyweightExercise)
                        .padding()
                    
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
                    .padding()
                }
                .padding()
            }
        }
    }
    
    private func addExercise() {
        guard !newExerciseName.isEmpty else { return }
        
        let exercise = Exercise(name: newExerciseName, isBodyweightExercise: isBodyweightExercise)
        modelContext.insert(exercise)
        
        // Reset fields
        newExerciseName = ""
        isBodyweightExercise = false
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        for index in offsets {
            let exercise = exercises[index]
            modelContext.delete(exercise)
        }
    }
}

#Preview {
    ExerciseLibraryView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
