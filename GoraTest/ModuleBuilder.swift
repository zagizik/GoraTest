import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(userId: Int?, router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = MainView()
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(userId: Int?, router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = DetailView()
        let presenter =  DetailPresenter(view: view, networkService: networkService, router: router, userId: userId)
        view.presenter = presenter
        return view
    }
}

