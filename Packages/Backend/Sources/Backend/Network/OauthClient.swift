import SwiftUI
import Combine
import Foundation
import KeychainAccess


public class OauthClient: ObservableObject {
    public enum State {
        case unknown, signedOut, signinInProgress, authenthicated(authToken: String)
    }
    
    @Published public var authState = State.unknown
    
    // Oauth URL
    private let baseURL = "https://www.reddit.com/api/v1/authorize"
    private let secrets: [String: AnyObject]?
    private let scopes = ["mysubreddits", "identity", "edit", "save", "vote", "subscribe", "read", "submit"]
    private let state = UUID().uuidString
    private let redirectURI = "redditos://auth"
    private let duration = "permanent"
    private let type = "code"
    
    // Keychain
    private let keychainService = "com.thomasricouard.RedditOs-reddit-token"
    private let keychainAuthTokenKey = "auth_token"
    
    public init() {
        if let path = Bundle.module.path(forResource: "secrets", ofType: "plist"),
           let secrets = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            self.secrets = secrets
        } else {
            self.secrets = nil
            print("Error: No secrets file found, you won't be able to login on Reddit")
        }
        
        let keychain = Keychain(service: keychainService)
        if let token = keychain[keychainAuthTokenKey] {
            authState = .authenthicated(authToken: token)
        } else {
            authState = .signedOut
        }
    }
    
    public func startOauthFlow() -> URL? {
        guard let clientId = secrets?["client_id"] as? String else {
            return nil
        }
        
        authState = .signinInProgress
        
        return URL(string: baseURL)!
            .appending("client_id", value: clientId)
            .appending("response_type", value: type)
            .appending("state", value: state)
            .appending("redirect_uri", value: redirectURI)
            .appending("duration", value: duration)
            .appending("scope", value: scopes.joined(separator: " "))
    }
    
    public func handleNextURL(url: URL) {
        authState = .signinInProgress
    }
}
