import UIKit

protocol NetworkServiceProtocol {
    func getUsers(complition: @escaping (Result<[User]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    
    func getUsers(complition: @escaping (Result<[User]?, Error>) -> Void) {
        let usrString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: usrString) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([User].self, from: data!)
                complition(.success(result))
                
            } catch {
                complition(.failure(error))
            }
        }.resume()
    }
}
