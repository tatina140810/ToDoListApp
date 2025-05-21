import Foundation

final class OpenTaskPresenter: OpenTaskPresenterProtocol {
   
    private let task: TaskEntity
    weak var view: OpenTaskViewProtocol?
    var interactor: OpenTaskInteractorProtocol?
    var router: OpenTaskRouterProtocol?
    
    init(task: TaskEntity){
        self.task = task
    }
    
    func viewDidLoad() {
        interactor?.fetchTask()
    }
    
    func editTask(title: String, description: String) {
        let date = DateFormatterHelper.getCurrentDate()
        interactor?.updateTask(title: title, description: description, date: date)
    }
    
    func deleteTask() {
        interactor?.deleteTask()
    }
    func updateTask(title: String, description: String, date: String) {
        if title.isEmpty {
            view?.showError("Название задачи не может быть пустым")
            return
        }
        let date = DateFormatterHelper.getCurrentDate()
        interactor?.updateTask(title: title, description: description, date: date)
    }
    func fetchTask() {
        interactor?.fetchTask()
    }
}

// MARK: - OpenTaskInteractorOutputProtocol
extension OpenTaskPresenter: OpenTaskInteractorOutputProtocol {
    func didSaveTask() {
    }
    
    func didFetchTask(title: String, description: String, date: String) {
        view?.displayTask(title: title, description: description, date: date)
    }
    
    func didFailWithError(_ error: String) {
        print("Ошибка: \(error)")
    }
    
    func didDeleteTask() {
        router?.navigateBack()
    }
}
