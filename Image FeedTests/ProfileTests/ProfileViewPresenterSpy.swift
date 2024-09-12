@testable import Image_Feed
import XCTest

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    init(profileService: ProfileService){
        self.profileService = profileService
    }
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var observer: Bool = false
    var viewDidClearDetailsAccount: Bool = false
    var didLogoutCalled: Bool = false
    var profileService: Image_Feed.ProfileService
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func exitProfile() {
        viewDidClearDetailsAccount = true
        didLogoutCalled = true
    }
    
    func profileServiceImageObserver() {
        observer = true
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
    
    var presenter: Image_Feed.ProfileViewPresenterProtocol
    
    func showAlertExit() {
        presenter.exitProfile()
    }
    
    func updateAvatar() {
        uppdateAvatar = true
    }
    
    var usernameLable = UILabel()
    var userLabel = UILabel()
    var bioLabel = UILabel()
    var uppdateAvatar: Bool = false
    var viewDidUpdateProfileDetails: Bool = false
    
    func updateProfileDetails(profile: Image_Feed.Profile?) {
        viewDidUpdateProfileDetails = true
        guard let profile = profile else { return }
        usernameLable.text = profile.name
        userLabel.text = profile.loginName
        bioLabel.text = profile.bio
    }
}

