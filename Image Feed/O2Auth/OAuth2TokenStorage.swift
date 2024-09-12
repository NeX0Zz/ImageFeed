import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init(){}
    private let bearerTokenKey = "OAuth2BearerToken"
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: bearerTokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: bearerTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: bearerTokenKey)
            }
        }
    }
}
