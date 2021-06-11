import UIKit

class DetailView: UITableViewController {
    
    var presenter: DetailPresenterProtocol!
    var photos: [Photo?] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photos"
        tableView.register(DetailViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewCell
        let photo = photos[indexPath.row]
        cell.titleLabel.text = photo?.title
        if let urlString = photo?.url {
            presenter.downloadImage(urlString: urlString) { image in
                if let image = image {
                    cell.posterView.image = image
                    cell.activity.stopAnimating()
                    cell.activity.hidesWhenStopped = true
                }
            }
        }    
        return cell
    }

}

// MARK: - DetailViewProtocol extension

extension DetailView: DetailViewProtocol {
    func setDetailView(photos: [Photo?]) {
        self.photos.append(contentsOf: photos)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
