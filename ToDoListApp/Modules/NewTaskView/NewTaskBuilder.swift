import UIKit

enum NewTaskBuilder {
    
    static func build() -> UIViewController {
        let view = NewTaskViewController()
        let presenter = NewTaskPresenter()
        let storageManager = StorageManager()
        let interactor = NewTaskInteractor(storageManager: storageManager)
        let router = NewTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
