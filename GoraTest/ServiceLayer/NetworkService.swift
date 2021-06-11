import UIKit

protocol NetworkServiceProtocol {
    var imageCache: NSCache<NSString, UIImage> { get set }
    func loadData<T: Codable>(of type: T.Type, urlString: String, completion: @escaping (Result<T, Error>) -> Void)
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func loadData<T>(of type: T.Type = T.self, urlString: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let `self` = self else {
                        return
                }
                
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
}
