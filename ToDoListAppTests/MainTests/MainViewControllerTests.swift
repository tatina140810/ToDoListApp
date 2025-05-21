import XCTest
@testable import ToDoListApp
import UIKit

final class MainViewControllerTests: XCTestCase {
    
    var viewController: MainViewController!
    var mockPresenter: MockMainPresenter!
    
    override func setUp() {
        super.setUp()
        viewController = MainViewController()
        mockPresenter = MockMainPresenter()
        viewController.presenter = mockPresenter
        _ = viewController.view  
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_callsPresenter() {
        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }
    
    func test_addTaskTapped_callsPresenter() {
        viewController.perform(#selector(MainViewController.addTaskTapped))
        XCTAssertTrue(mockPresenter.addTaskTappedCalled)
    }
    
    func test_updateSearchResults_withQuery_callsSearchTask() {
        viewController.searchController.searchBar.text = "example"
        viewController.updateSearchResults(for: viewController.searchController)
        XCTAssertEqual(mockPresenter.searchTaskQuery, "example")
    }
    
    func test_updateSearchResults_emptyQuery_callsResetSearch() {
        viewController.searchController.searchBar.text = ""
        viewController.updateSearchResults(for: viewController.searchController)
        XCTAssertTrue(mockPresenter.resetSearchCalled)
    }
    
    func test_reloadData_updatesTableView() {
        mockPresenter.filteredTasks = [
            Task(title: "Test", description: "Desc", date: "Today", completed: false)
        ]
        viewController.reloadData()
        
        let rowCount = viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rowCount, 1)
    }
    
    
    func test_tableView_didSelectRow_opensTaskDetails() {
        // Setup
        let task = Task(title: "Task", description: "Desc", date: "Today", completed: false)
        mockPresenter.filteredTasks = [task]
        
        let coreDataStack = CoreDataTestStack()
        let context = coreDataStack.context
        
        let taskEntity = TaskEntity(context: context)
        taskEntity.title = "Task"
        taskEntity.taskDescription = "Desc"
        taskEntity.taskDate = "Today"
        mockPresenter.taskEntityes = [taskEntity]
        
        
        viewController.tableView(viewController.tableView,
                                 didSelectRowAt: IndexPath(row: 0, section: 0))
        
        
        XCTAssertEqual(mockPresenter.openTaskDetailsCalledWith?.title, "Task")
    }
}
