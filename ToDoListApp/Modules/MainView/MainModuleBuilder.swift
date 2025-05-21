import UIKit

enum MainModuleBuilder {
    
    static func build() -> MainViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let storageManager = StorageManager() 
        let interactor = MainInteractor(storageManager: storageManager)
        let router = MainRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
}
