import Foundation

final class ProfileService {
    
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
    private init() {}
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        let request = profileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(data: body)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    func profileRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)" + "/me")
        else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
     func clean() {
        profile = nil
    }
}
