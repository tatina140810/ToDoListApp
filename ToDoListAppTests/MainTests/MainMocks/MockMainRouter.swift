import Foundation
@testable import ToDoListApp

final class MockMainRouter: MainRouterProtocol {
    var navigateToNewTaskCalled = false
    var navigateToOpenTaskCalled = false
    var openedTask: TaskEntity?
    
    func navigateToOpenTask(task: TaskEntity) {
        navigateToOpenTaskCalled = true
        openedTask = task
    }
    
    func navigateToNewTask() {
        navigateToNewTaskCalled = true
    }
}
