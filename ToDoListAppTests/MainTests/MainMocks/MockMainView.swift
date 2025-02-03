import Foundation
@testable import ToDoListApp

final class MockMainView: MainViewProtocol {
    var startLoadingCalled = false
    var stopLoadingCalled = false
    var reloadDataCalled = false
    var showErrorCalled = false
    var errorMessage: String?

    func startLoading() {
        startLoadingCalled = true
    }

    func stopLoading() {
        stopLoadingCalled = true
    }

    func reloadData() {
        reloadDataCalled = true
    }

    func showError(_ message: String) {
        showErrorCalled = true 
        errorMessage = message
    }
}





