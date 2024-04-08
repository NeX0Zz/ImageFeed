import Foundation

struct UserResult: Codable {
    let profileImage: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let largeImage: [String:String]
        
        init(data: UserResult) {
            self.largeImage = data.profileImage
        }
    }
}

enum ProfileImageError: Error {
    case invalidURL
    case noData
}

final class ProfileImageService {
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private init() {}
    
    func fetchProfileImageURL(username: String,_ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        let token = OAuth2TokenStorage.shared.token
        guard let token = token else { return }
        let request = profileImageRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatarUrl = UserResult.ProfileImage(data: body)
                avatarURL = avatarUrl.largeImage["large"]
                completion(.success(self.avatarURL ?? ""))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

private extension ProfileImageService {
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)" + "/users/" + username) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    } 
}
