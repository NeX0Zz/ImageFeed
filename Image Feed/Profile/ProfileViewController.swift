import UIKit
import WebKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileImageService = ProfileImageService.shared
    private var profileService = ProfileService.shared
    private var profileLogoutService = ProfileLogoutService.shared
    private var token = OAuth2TokenStorage.shared.token
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var usernameLable: UILabel = {
        let usernameLable = UILabel()
        usernameLable.text = "Екатерина Новикова"
        usernameLable.textColor = UIColor(named: "YP White")
        usernameLable.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return usernameLable
    }()
    
    private lazy var userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.text = "@ekaterina_nov"
        userLabel.textColor = UIColor(named: "YP Gray")
        userLabel.font = UIFont.systemFont(ofSize: 13)
        return userLabel
    }()
    
    private lazy var bioLabel: UILabel = {
        let anyLabel = UILabel()
        anyLabel.text = "Hello, world!"
        anyLabel.textColor = UIColor(named: "YP White")
        anyLabel.font = UIFont.systemFont(ofSize: 13)
        return anyLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let profileImage = UIImage(named: "active")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton))
        button.tintColor = .red
        return button
    }()
    
    // MARK: - Overrides funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails(profile: profileService.profile)
        profileServiceImageObserver()
        view.backgroundColor = UIColor(named: "YP Black")
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    // MARK: - Private funcs
    
    private func profileServiceImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL) else { return }
        
        let process = RoundCornerImageProcessor(cornerRadius: 61)
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "active"),
                              options: [.processor(process)])
        imageView.kf.indicatorType = .activity
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 34
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        self.usernameLable.text = profile.name
        self.userLabel.text = profile.loginName
        self.bioLabel.text = profile.bio
        
    }
    
    // MARK: - funcs
    
    func setup(){
        [usernameLable, userLabel, bioLabel, button, imageView].forEach {
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
            bioLabel.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    // MARK: - @objc
    
    @objc
    private func didTapButton() {
        let alertController = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены, что хотите выйти?",
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            KeychainWrapper.standard.removeAllKeys()
            profileLogoutService.logout()
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
}
