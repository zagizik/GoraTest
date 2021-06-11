import UIKit

class DetailViewCell: UITableViewCell {
    
    let activity = UIActivityIndicatorView(style: .large)
    
    let posterView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stack = UIStackView(arrangedSubviews: [posterView, titleLabel])
        stack.axis = .vertical
        contentView.addSubview(stack)
   
        stack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        posterView.anchor(top: stack.topAnchor, leading: stack.leadingAnchor, bottom: titleLabel.topAnchor, trailing: stack.trailingAnchor, padding: .init(top: 0, left: 0 , bottom: 10, right: 0), size: .init(width: UIScreen.main.bounds.width - 32 , height: UIScreen.main.bounds.width - 32))
        titleLabel.anchor(top: nil, leading: stack.leadingAnchor, bottom: stack.bottomAnchor, trailing: stack.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 10, right: 5))

        stack.backgroundColor = .white
        contentView.addSubview(activity)
        activity.center = stack.center
        activity.startAnimating()
        stack.layer.shadowOpacity = 0.5
        stack.layer.cornerRadius = 10
        stack.layer.shadowRadius = 3
        stack.layer.shadowOffset = CGSize.zero
        stack.setNeedsLayout()
        stack.layoutIfNeeded()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
