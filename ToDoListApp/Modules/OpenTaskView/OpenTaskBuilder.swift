import UIKit

enum OpenTaskBuilder{
    
    static func build(with task: TaskEntity) -> UIViewController {
        let view = OpenTaskViewController()
        let presenter = OpenTaskPresenter(task: task)
        let storageManager = StorageManager()
        let interactor = OpenTaskInteractor(storageManager: storageManager)
        let router = OpenTaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        interactor.task = task
        
        return view
    }
}
