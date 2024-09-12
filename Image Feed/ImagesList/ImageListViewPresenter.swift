import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var imageListService: ImagesListService {get}
    func viewDidLoad()
    func photoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPhotosNextPage()
}
final class ImageListViewPresenter: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var imagesListServiceObserver: NSObjectProtocol?
    let imageListService = ImagesListService.shared
    
    func viewDidLoad() {
        configureNotificationObserver()
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func configureNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imageListService.fetchPhotosNextPage()
    }
    
    func photoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imageListService.changeLike(photoId: photoId,isLike: isLike) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print("\(error)")
            }
        }
    }
}
