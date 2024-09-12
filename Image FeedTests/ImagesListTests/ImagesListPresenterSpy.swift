@testable import Image_Feed
import XCTest
import Foundation

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    init(imageListService: ImagesListService){
        self.imageListService = imageListService
    }
    
    var imageListService: Image_Feed.ImagesListService
    var view: Image_Feed.ImagesListViewControllerProtocol?
    var setLikeCall = false
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
    }
    
    func photoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        setLikeCall = true
    }
    
}
    

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: Image_Feed.ImagesListViewPresenterProtocol?
    
    func updateTableViewAnimated() {
    }
    
    var photos: [Image_Feed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func addPhotoLike() {
        presenter?.photoLike(photoId: "photo", isLike: true) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                print("Error")
            }
        }
    }
}
