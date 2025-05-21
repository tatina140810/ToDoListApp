import Foundation
@testable import ToDoListApp

final class MockMainView: MainViewProtocol {
    
    private(set) var reloadDataCalled = false
    private(set) var showErrorCalled = false
    private(set) var startLoadingCalled = false
    private(set) var stopLoadingCalled = false
    private(set) var errorMessage: String?
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func stopLoading() {
        stopLoadingCalled = true
    }
}
