import Foundation
@testable import ToDoListApp

final class MockOpenTaskInteractor: OpenTaskInteractorProtocol {
    var fetchTaskCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var updatedTitle: String?
    var updatedDescription: String?
    var updatedDate: String?

    func fetchTask() {
        fetchTaskCalled = true
    }

    func updateTask(title: String, description: String, date: String) {
        updateTaskCalled = true
        updatedTitle = title
        updatedDescription = description
        updatedDate = date
    }

    func deleteTask() {
        deleteTaskCalled = true
    }
}
