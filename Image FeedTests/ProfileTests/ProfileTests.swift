@testable import Image_Feed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let profileService = ProfileService.shared
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsCleanCookies() {
        let profileService = ProfileService.shared
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenterSpy(profileService: profileService)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        _ = profileViewController.view
        profilePresenter.exitProfile()
        XCTAssertTrue(profilePresenter.viewDidClearDetailsAccount)
    }
    
    
    func testPresenterCallsUpdateProfile() {
        let profileService = ProfileService.shared
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        let profileViewController = ProfileViewControllerSpy(presenter: presenter)
        let profilePresenter = ProfileViewPresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        let bioLablee = "Hiii"
        let username = "Nikolaev"
        let nameLabel = "Denis Nikolaev"
        let firstName = "Denis"
        let lastName = "Nikolaev"
        let loginNameLabel = "@nexoz"
        let profile = Profile(data: ProfileResult(username: username,
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      bio: bioLablee))
        
        profileViewController.updateProfileDetails(profile: profile)
        XCTAssertTrue(profileViewController.viewDidUpdateProfileDetails)
        XCTAssertEqual(profileViewController.usernameLable .text, nameLabel)
        XCTAssertEqual(profileViewController.userLabel.text, loginNameLabel)
        XCTAssertEqual(profileViewController.bioLabel.text, bioLablee)
    }
    
    func testExitProfile() {
        let profileService = ProfileService.shared
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        view.showAlertExit()
        XCTAssertTrue(presenter.didLogoutCalled)
    }
}
