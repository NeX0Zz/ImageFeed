import Foundation
struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let width: CGFloat
    let height: CGFloat
    let likes: Int
    let likedByUser: Bool?
    let description: String?
    let urls: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
