import UIKit

protocol MainViewProtocol: AnyObject {
    func succes(_ users: [User]?)
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init (view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getUsers()
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol?
    var router: RouterProtocol?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getUsers()
    }
    
    func getUsers() {
        networkService?.getUsers(complition: { result in
            switch result {
            case .failure(let error):
                self.view?.failure(error: error)
            case.success(let users):
                self.view?.succes(users)
            }
        })
    }
}
