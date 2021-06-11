import UIKit

protocol DetailViewProtocol: AnyObject {
    var photos: [Photo?] { get set }
    func setDetailView(photos: [Photo?])
}

protocol DetailPresenterProtocol: AnyObject {
    init (view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, userId: Int?)
    func getAlbums(userId: Int?, completion: @escaping ([Album?]) -> Void)
    func getPhotos(albums: [Album?], completion: @escaping ([Photo?]) -> Void)
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void)
    func tapToRoot()
}

class DetailPresenter: DetailPresenterProtocol {
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        networkService.downloadImage(urlString: urlString) { image in
            completion(image)
        }
    }

    
    weak var view: DetailViewProtocol?
    let networkService: NetworkServiceProtocol
    var router: RouterProtocol?
    var userId: Int?
    var photos: [Photo?] = [] {
        didSet{
            self.view?.setDetailView(photos: photos)
        }
    }
    
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, userId: Int?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.userId = userId
        getAlbums(userId: userId){ [weak self] albums in
            self?.getPhotos(albums: albums) { photos in
                self?.photos += photos
            }
        }
    }
    
    func getAlbums(userId: Int?, completion: @escaping ([Album?]) -> Void) {
        let urlStringAlbum = "https://jsonplaceholder.typicode.com/albums?userId=\(userId!)"
        networkService.loadData(of: [Album].self, urlString: urlStringAlbum) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let albums):
                
                completion(albums)
            }
        }
    }
    
    func getPhotos(albums: [Album?], completion: @escaping ([Photo?]) -> Void) {
        for album in albums {
            guard let albumId = album?.id else { return }
            let urlStringPhoto = "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)"
            self.networkService.loadData(of: [Photo?].self, urlString: urlStringPhoto) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case.success(let photo):
                    completion(photo)
                }
            }
        }
    }
    
    func tapToRoot() {
        router?.popToRoot()
    }
}
