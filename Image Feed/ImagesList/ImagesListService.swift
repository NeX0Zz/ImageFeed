import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let dateFormatter = ISO8601DateFormatter()
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private init(){}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = imageRequestToken(token: token, perPage: "10", page: String(nextPage))
        let task = urlSession.objectTask(for: request){ [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    body[..<(body.count - 2)].forEach {
                        let photo = self.convertToPhoto(from: $0)
                        self.photos.append(photo)
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["active" : self.photos])
                    self.task = nil
                case .failure:
                    assertionFailure("no_active")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String,isLike: Bool,_ completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard task == nil else { return }
        guard let token = oAuth2TokenStorage.token else { return }
        let request = isLike ? disableLikeRequest(token, photoId: photoId) : likeRequest(token, photoId: photoId)
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let isLiked = body.photo?.likedByUser ?? false
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            fullImageUrl: photo.largeImageURL,
                            isLiked: isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(isLiked))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

private extension ImagesListService {
    private func imageRequestToken(token: String, perPage: String, page: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: URL(string: "\(Constants.defaultBaseURL)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func likeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "POST",
            baseURL: URL(string: "\(Constants.defaultBaseURL)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func disableLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "DELETE",
            baseURL: URL(string: "\(Constants.defaultBaseURL)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convertToPhoto(from photoResult: PhotoResult) -> Photo {
        let photo = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width,height: photoResult.height),
            createdAt: self.dateFormatter.date(from:photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls?.thumbImageURL ?? "",
            largeImageURL: photoResult.urls?.largeImageURL ?? "",
            fullImageUrl: photoResult.urls?.largeImageURL ?? "",
            isLiked: photoResult.likedByUser ?? false)
        return photo
    }
}
