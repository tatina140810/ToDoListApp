import Foundation
@testable import ToDoListApp

final class MockOpenTaskRouter: OpenTaskRouterProtocol {
    var navigateBackCalled = false

    func navigateBack() {
        navigateBackCalled = true
    }
}
