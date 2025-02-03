import Foundation
@testable import ToDoListApp

final class MockNewTaskInteractor: NewTaskInteractorProtocol {
    var saveTaskCalled = false
    var savedTaskTitle: String?
    var savedTaskDescription: String?
    var savedTaskDate: String?

    func saveTask(title: String, description: String, date: String) {
        saveTaskCalled = true
        savedTaskTitle = title
        savedTaskDescription = description
        savedTaskDate = date
    }
}
