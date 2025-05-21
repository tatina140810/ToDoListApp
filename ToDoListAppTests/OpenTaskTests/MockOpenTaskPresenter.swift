import Foundation
@testable import ToDoListApp

final class MockOpenTaskPresenter: OpenTaskInteractorOutputProtocol {
    var didFetchTaskCalled = false
    var didFailWithErrorCalled = false
    var didSaveTaskCalled = false
    var didDeleteTaskCalled = false
    var fetchedTitle: String?
    var fetchedDescription: String?
    var fetchedDate: String?
    var errorMessage: String?

    func didFetchTask(title: String, description: String, date: String) {
        didFetchTaskCalled = true
        fetchedTitle = title
        fetchedDescription = description
        fetchedDate = date
    }

    func didFailWithError(_ error: String) {
        didFailWithErrorCalled = true
        errorMessage = error
    }

    func didSaveTask() {
        didSaveTaskCalled = true
    }

    func didDeleteTask() {
        didDeleteTaskCalled = true
    }
}
