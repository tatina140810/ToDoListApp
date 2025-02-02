import XCTest
@testable import ToDoListApp

final class MockMainInteractor: MainInteractorProtocol {
    var taskEntities: [TaskEntity] = []

    var fetchTasksCalled = false
    var saveTaskCalled = false
    var deleteTaskCalled = false
    var updateTaskCalled = false
    var loadTaskCalled = false

    func setTaskEntities(_ tasks: [ToDoListApp.TaskEntity]) {
        self.taskEntities = tasks
    }

    func saveTask(_ task: ToDoListApp.TaskEntity) {
        saveTaskCalled = true
    }

    func updateTask(_ task: ToDoListApp.TaskEntity, completed: Bool) {
        updateTaskCalled = true
    }

    func loadTasks() {
        loadTaskCalled = true
    }

    func fetchTasks() {
        fetchTasksCalled = true
    }

    func deleteTask(_ task: TaskEntity) {
        deleteTaskCalled = true
    }
}
