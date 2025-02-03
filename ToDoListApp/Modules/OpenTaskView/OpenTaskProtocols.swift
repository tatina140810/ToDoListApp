import Foundation

// MARK: - View -> Presenter
protocol OpenTaskViewProtocol: AnyObject {
    func displayTask(title: String, description: String, date: String)
    func showError(_ message: String)
}

// MARK: - Presenter -> View
protocol OpenTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func editTask(title: String, description: String)
    func deleteTask()
    func updateTask(title: String, description: String, date: String)
    func fetchTask()
}

// MARK: - Presenter -> Interactor
protocol OpenTaskInteractorProtocol: AnyObject {
    func fetchTask()
    func updateTask(title: String, description: String, date: String)
    func deleteTask()
    
}

// MARK: - Interactor -> Presenter
protocol OpenTaskInteractorOutputProtocol: AnyObject {
    func didFetchTask(title: String, description: String, date: String)
    func didFailWithError(_ error: String)
    func didDeleteTask()
    func didSaveTask()
    
}

// MARK: - Router
protocol OpenTaskRouterProtocol: AnyObject {
    func navigateBack()
}
