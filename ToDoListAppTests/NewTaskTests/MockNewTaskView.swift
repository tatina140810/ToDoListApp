import Foundation

@testable import ToDoListApp

class MockNewTaskView: NewTaskViewProtocol {
    var showErrorCalled = false
       var dismissViewCalled = false
       var errorMessage: String?

       func showError(_ message: String) {
           showErrorCalled = true
           errorMessage = message
       }

       func dismissView() {
           dismissViewCalled = true
       }
}
