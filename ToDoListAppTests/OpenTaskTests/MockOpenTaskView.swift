import Foundation
@testable import ToDoListApp

final class MockOpenTaskView: OpenTaskViewProtocol {
    var displayTaskCalled = false
    var showErrorCalled = false
    var displayedTitle: String?
    var displayedDescription: String?
    var displayedDate: String?
    var errorMessage: String?

    func displayTask(title: String, description: String, date: String) {
        displayTaskCalled = true
        displayedTitle = title
        displayedDescription = description
        displayedDate = date
    }

    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}

