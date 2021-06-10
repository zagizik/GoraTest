import UIKit

class MainView: UITableViewController {

    var presenter: MainViewPresenterProtocol!
    var users: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.title = "Users"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = users?[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
}

extension MainView: MainViewProtocol {
    func succes(_ users: [User]?) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

