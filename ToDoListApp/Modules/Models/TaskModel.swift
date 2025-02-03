import Foundation

struct Task {
    let title: String
    let description: String
    let date: String
    var completed: Bool
    
    mutating func toggleCompletion() {
        completed.toggle()
    }
}
