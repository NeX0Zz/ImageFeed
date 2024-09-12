@testable import Image_Feed
import XCTest
import Foundation

final class ImagesListTests: XCTestCase {
        
    func testViewControllerCallsViewDidLoad(){
        let imageListService = ImagesListService.shared
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imageListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    
    func testLike() {
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imageListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
       
        view.addPhotoLike()
        XCTAssertTrue(presenter.setLikeCall)
    }
    
}
