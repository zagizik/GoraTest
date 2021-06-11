import UIKit

protocol MainViewProtocol: AnyObject {
    func succes(_ users: [User]?)
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init (view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getUsers()
    func tapOnUser(userId: Int?)
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    fileprivate let networkService: NetworkServiceProtocol?
    fileprivate var router: RouterProtocol?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getUsers()
    }
    
    func getUsers() {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        networkService?.loadData(of: [User].self, urlString: urlString)  { [weak self] result in
            switch result {
            case .failure(let error):
                self?.view?.failure(error: error)
            case.success(let users):
                self?.view?.succes(users)
            }
        }
    }
    
    func tapOnUser(userId: Int?){
        router?.showDetail(userId: userId)
    }
}
