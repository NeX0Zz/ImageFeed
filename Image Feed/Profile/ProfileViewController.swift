import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var usernameLable: UILabel = {
        let usernameLable = UILabel()
        usernameLable.text = "Екатерина Новикова"
        usernameLable.textColor = UIColor(named: "YP White")
        usernameLable.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return usernameLable
    }()

    private var userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.text = "@ekaterina_nov"
        userLabel.textColor = UIColor(named: "YP Gray")
        userLabel.font = UIFont.systemFont(ofSize: 13)
        return userLabel
    }()
    
    private var anyLabel: UILabel = {
        let anyLabel = UILabel()
        anyLabel.text = "Hello, world!"
        anyLabel.textColor = UIColor(named: "YP White")
        anyLabel.font = UIFont.systemFont(ofSize: 13)
        return anyLabel
    }()
    
    private var imageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private var button: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton))
        button.tintColor = .red
        return button
    }()
    
    // MARK: - Overrides funcs
    
    override func loadView() {
        super.loadView()
        setup()
    }

    // MARK: - funcs

    func setup(){
        [usernameLable, userLabel, anyLabel, button, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            usernameLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            usernameLable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userLabel.leadingAnchor.constraint(equalTo: usernameLable.leadingAnchor),
            userLabel.topAnchor.constraint(equalTo: usernameLable.bottomAnchor, constant: 8),
            anyLabel.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            anyLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    // MARK: - Gestures
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}

