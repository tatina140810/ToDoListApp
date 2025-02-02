import XCTest
@testable import ToDoListApp

final class MockMainView: MainViewProtocol {
    var reloadDataCalled = false
    var showErrorCalled = false
    func reloadData() {
        reloadDataCalled = true
    }
    func showError(_ message: String) {
        showErrorCalled = true
    }
}



