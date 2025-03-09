import SwiftUI
import SwiftData

struct CurrentWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    
    @State private var currentSession: WorkoutSession?
    @State private var showingExerciseSelection = false
    @State private var showingDatePicker = false
    @State private var newExerciseName = ""
    private var filteredExercises: [Exercise] {
        exercises.filter { $0.name.lowercased().contains(newExerciseName.lowercased()) }
    }
    @State private var newWeight = ""
    @State private var isBodyweightExercise = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Session date/time header
                HStack {
                    Text(currentSession?.formattedDate ?? "New Workout")
                        .font(.headline)
                    
                    Button(action: {
                        showingDatePicker = true
                    }) {
                        Image(systemName: "calendar")
                    }
                    .padding(.leading, 8)
                }
                .padding()
                
                // Exercise list
                if let session = currentSession {
                    ExerciseListView(
                        session: session,
                        groupedExercises: groupedExercises(for: session),
                        addSet: { exercise in addSet(for: exercise, in: session) },
                        setsForExercise: { exercise in setsForExercise(exercise, in: session) },
                        formatRestTime: formatRestTime
                    )
                } else {
                    // No active session
                    VStack(spacing: 20) {
                        Text("No active workout session")
                            .font(.headline)
                        
                        Button(action: {
                            startNewSession()
                        }) {
                            Text("Start New Workout")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    Spacer()
                }
                
                // Add exercise section
                if currentSession != nil {
                    ExerciseSectionView(
                        newExerciseName: $newExerciseName,
                        isBodyweightExercise: $isBodyweightExercise,
                        newWeight: $newWeight,
                        filteredExercises: filteredExercises,
                        addExercise: addExercise,
                        showingExerciseSelection: $showingExerciseSelection
                    )
                }
            }
            .navigationTitle("Current Workout")
            .toolbar {
                if currentSession != nil {
                    Button("Finish") {
                        finishWorkout()
                    }
                }
            }
            .sheet(isPresented: $showingExerciseSelection) {
                ExerciseSelectionView(onSelect: { exercise in
                    if let session = currentSession {
                        addExistingExercise(exercise, to: session)
                    }
                    showingExerciseSelection = false
                })
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(date: currentSession?.date ?? Date()) { newDate in
                    if let session = currentSession {
                        session.date = newDate
                    }
                    showingDatePicker = false
                }
            }
        }
        .onAppear {
            if currentSession == nil {
                startNewSession()
            }
        }
    }
    
    private func startNewSession() {
        let session = WorkoutSession()
        modelContext.insert(session)
        currentSession = session
    }
    
    private func addExercise() {
        guard let session = currentSession, !newExerciseName.isEmpty else { return }
        
        // Check if exercise already exists
        let existingExercise = exercises.first { $0.name.lowercased() == newExerciseName.lowercased() }
        
        if let exercise = existingExercise {
            addExistingExercise(exercise, to: session)
        } else {
            let exercise = Exercise(name: newExerciseName, isBodyweightExercise: isBodyweightExercise)
            modelContext.insert(exercise)
            
            let set = WorkoutSet(
                weight: isBodyweightExercise ? nil : Double(newWeight) ?? 0,
                setNumber: 1
            )
            set.exercise = exercise
            set.session = session
            modelContext.insert(set)
        }
        
        // Reset fields
        newExerciseName = ""
        newWeight = ""
    }
    
    private func addExistingExercise(_ exercise: Exercise, to session: WorkoutSession) {
        // Find the last weight used for this exercise
        let lastWeight = exercise.sets
            .sorted { $0.timestamp > $1.timestamp }
            .first?.weight
        
        let set = WorkoutSet(
            weight: exercise.isBodyweightExercise ? nil : lastWeight,
            setNumber: 1
        )
        set.exercise = exercise
        set.session = session
        modelContext.insert(set)
        
        // Reset fields
        newExerciseName = ""
        newWeight = ""
    }
    
    private func addSet(for exercise: Exercise, in session: WorkoutSession) {
        let existingSets = setsForExercise(exercise, in: session)
        let nextSetNumber = existingSets.count + 1
        
        // Get weight from previous set if available
        let previousWeight = existingSets.last?.weight
        
        let set = WorkoutSet(
            weight: previousWeight,
            setNumber: nextSetNumber
        )
        set.exercise = exercise
        set.session = session
        modelContext.insert(set)
    }
    
    private func finishWorkout() {
        currentSession = nil
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
    
    private func formatRestTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }
}

struct DatePickerView: View {
    @State private var selectedDate: Date
    let onSave: (Date) -> Void
    
    init(date: Date, onSave: @escaping (Date) -> Void) {
        self._selectedDate = State(initialValue: date)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Workout Date",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            .navigationTitle("Edit Date")
            .toolbar {
                Button("Save") {
                    onSave(selectedDate)
                }
            }
        }
    }
}

#Preview {
    CurrentWorkoutView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
