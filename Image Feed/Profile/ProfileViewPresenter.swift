import WebKit
import UIKit
import SwiftKeychainWrapper

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func exitProfile()
    func profileServiceImageObserver()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    var oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    func viewDidLoad() {
        profileServiceImageObserver()
    }
    
    func exitProfile() {
        oAuth2TokenStorage.token = nil
        profileLogoutService.logout()
        ProfileService.shared.clean()
        KeychainWrapper.standard.removeAllKeys()
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
     func profileServiceImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
         view?.updateAvatar()
    }
}
