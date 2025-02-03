import XCTest

@testable import ToDoListApp

final class MainInteractorTests: XCTestCase {
    var interactor: MainInteractor!
    var mockPresenter: MockMainPresenter!
    
    override func setUp() {
        super.setUp()
       
        interactor  = MainInteractor()
        mockPresenter = MockMainPresenter()
        interactor.presenter = mockPresenter

        let context = StorageManager.shared.context
        let task = TaskEntity(context: context)
        task.title = "Тестовая задача"

        StorageManager.shared.saveContext() 

        interactor.setTaskEntities([task])
    }
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testFetchTasks_ShouldReturnTasks() {
        let context = StorageManager.shared.context
        let task = TaskEntity(context: context)
        task.title = "Тестовая задача"
        task.taskDescription = "Описание задачи"
        task.taskDate = "2025-02-04"
        task.completed = false

        StorageManager.shared.saveContext()

        let expectation = self.expectation(description: "Fetch tasks should complete")

        interactor.fetchTasks()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.interactor.taskEntityes.isEmpty, "⚠️ taskEntities оказался пустым")
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled, "⚠️ didFetchTasks() не был вызван")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testDeleteTask_shouldDeleteTask() {
        let context = StorageManager.shared.context
        let task = TaskEntity(context: context)
        task.title = "Удаляемая задача"

        StorageManager.shared.saveContext()

        interactor.presenter = mockPresenter
        interactor.setTaskEntities([task])

        let expectation = self.expectation(description: "Ожидание удаления задачи")

        interactor.deleteTask(task)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockPresenter.didDeleteTaskCalled, "didDeleteTask() не был вызван")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }


}
