import UIKit

final class MainRouter: MainRouterProtocol {
    
    
    weak var viewController: UIViewController?
    
    static func createModule() -> MainViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let router = MainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToOpenTask(task: TaskEntity) {
        let openTaskVC = OpenTaskRouter.createModule(with: task)
        viewController?.navigationController?.pushViewController(openTaskVC, animated: true)
    }
    
    
    func navigateToNewTask() {
        let newTaskVC = NewTaskRouter.createModule()
        viewController?.navigationController?.pushViewController(newTaskVC, animated: true)
    }
}
