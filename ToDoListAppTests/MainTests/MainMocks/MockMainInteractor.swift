import Foundation
@testable import ToDoListApp

final class MockMainInteractor: MainInteractorProtocol {
    var fetchTasksCalled = false
    var saveTaskCalled = false
    var deleteTaskCalled = false
    var updateTaskCalled = false
    var loadTasksCalled = false
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func saveTask(_ task: TaskEntity) {
        saveTaskCalled = true
    }
    
    func deleteTask(_ task: TaskEntity) {
        deleteTaskCalled = true
    }
    
    func updateTask(_ task: TaskEntity, completed: Bool) {
        updateTaskCalled = true
    }
    
    func loadTasks() {
        loadTasksCalled = true
    }
    
    func setTaskEntities(_ tasks: [TaskEntity]) {}
}
