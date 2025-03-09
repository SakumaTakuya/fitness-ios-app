import Foundation
import SwiftData

@Model
final class Exercise {
    var id: UUID
    var name: String
    var isBodyweightExercise: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.exercise)
    var sets: [WorkoutSet] = []
    
    init(id: UUID = UUID(), name: String, isBodyweightExercise: Bool = false) {
        self.id = id
        self.name = name
        self.isBodyweightExercise = isBodyweightExercise
    }
}

@Model
final class WorkoutSession {
    var id: UUID
    var date: Date
    
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.session)
    var sets: [WorkoutSet] = []
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@Model
final class WorkoutSet {
    var id: UUID
    var weight: Double?  // Optional for bodyweight exercises
    var setNumber: Int
    var restTimeSeconds: Int?
    var timestamp: Date
    
    // Relationships
    var exercise: Exercise?
    var session: WorkoutSession?
    
    init(id: UUID = UUID(), weight: Double? = nil, setNumber: Int, restTimeSeconds: Int? = nil, timestamp: Date = Date()) {
        self.id = id
        self.weight = weight
        self.setNumber = setNumber
        self.restTimeSeconds = restTimeSeconds
        self.timestamp = timestamp
    }
}
