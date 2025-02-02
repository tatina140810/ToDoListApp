import XCTest
@testable import ToDoListApp

final class MockMainRouter: MainRouterProtocol {
    func navigateToOpenTask(task: ToDoListApp.TaskEntity) {}

    func navigateToNewTask() {}
}
