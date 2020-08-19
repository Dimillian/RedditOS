import SwiftUI
import Combine
import Foundation
import KeychainAccess


public class OauthClient: ObservableObject {
    public enum State {
        case unknown, signedOut, signinInProgress
        case authenthicated(authToken: String)
    }
    
    struct AuthTokenResponse: Decodable {
        let accessToken: String
        let tokenType: String
        let refreshToken: String?
    }
    
    static public let shared = OauthClient()
    
    @Published public var authState = State.unknown
    
    // Oauth URL
    private let baseURL = "https://www.reddit.com/api/v1/authorize"
    private let secrets: [String: AnyObject]?
    private let scopes = ["mysubreddits", "identity", "edit", "save",
                          "vote", "subscribe", "read", "submit", "history",
                          "privatemessages"]
    private let state = UUID().uuidString
    private let redirectURI = "redditos://auth"
    private let duration = "permanent"
    private let type = "code"
    
    // Keychain
    private let keychainService = "com.thomasricouard.RedditOs-reddit-token"
    private let keychainAuthTokenKey = "auth_token"
    private let keychainAuthTokenRefreshToken = "refresh_auth_token"
    
    // Request
    private var requestCancellable: AnyCancellable?
    private var refreshCancellable: AnyCancellable?
    
    private var refreshTimer: Timer?
    
    init() {
        if let path = Bundle.module.path(forResource: "secrets", ofType: "plist"),
           let secrets = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            self.secrets = secrets
        } else {
            self.secrets = nil
            print("Error: No secrets file found, you won't be able to login on Reddit")
        }
        
        let keychain = Keychain(service: keychainService)
        if let token = keychain[keychainAuthTokenKey],
           let refresh = keychain[keychainAuthTokenRefreshToken] {
            authState = .authenthicated(authToken: token)
            DispatchQueue.main.async {
                self.refreshToken(refreshToken: refresh)
            }
        } else {
            authState = .signedOut
        }
        
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 60.0 * 30, repeats: true) { _ in
            switch self.authState {
            case .authenthicated(_):
                let keychain = Keychain(service: self.keychainService)
                if let refresh = keychain[self.keychainAuthTokenRefreshToken] {
                    self.refreshToken(refreshToken: refresh)
                }
            default:
                break
            }
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
        if url.absoluteString.hasPrefix(redirectURI),
           url.queryParameters?.first(where: { $0.value == state }) != nil,
           let code = url.queryParameters?.first(where: { $0.key == type }){
            authState = .signinInProgress
            requestCancellable = makeOauthPublisher(code: code.value)?
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in },
                receiveValue: { response in
                    let keychain = Keychain(service: self.keychainService)
                    keychain[self.keychainAuthTokenKey] = response.accessToken
                    keychain[self.keychainAuthTokenRefreshToken] = response.refreshToken
                    self.authState = .authenthicated(authToken: response.accessToken)
                })
        }
    }
    
    public func logout() {
        authState = .signedOut
        let keychain = Keychain(service: keychainService)
        keychain[keychainAuthTokenKey] = nil
        keychain[keychainAuthTokenRefreshToken] = nil
    }
    
    private func refreshToken(refreshToken: String) {
        refreshCancellable = makeRefreshOauthPublisher(refreshToken: refreshToken)?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
            receiveValue: { response in
                self.authState = .authenthicated(authToken: response.accessToken)
                let keychain = Keychain(service: self.keychainService)
                keychain[self.keychainAuthTokenKey] = response.accessToken
            })
    }
    
    private func makeOauthPublisher(code: String) -> AnyPublisher<AuthTokenResponse, NetworkError>? {
        let params: [String: String] = ["code": code,
                                        "grant_type": "authorization_code",
                                        "redirect_uri": redirectURI]
        return API.shared.request(endpoint: .accessToken,
                                  basicAuthUser: secrets?["client_id"] as? String,
                                  httpMethod: "POST",
                                  isJSONEndpoint: false,
                                  queryParamsAsBody: true,
                                  params: params).eraseToAnyPublisher()
    }
    
    private func makeRefreshOauthPublisher(refreshToken: String) -> AnyPublisher<AuthTokenResponse, NetworkError>? {
        let params: [String: String] = ["grant_type": "refresh_token",
                                         "refresh_token": refreshToken]
        return API.shared.request(endpoint: .accessToken,
                                  basicAuthUser: secrets?["client_id"] as? String,
                                  httpMethod: "POST",
                                  isJSONEndpoint: false,
                                  queryParamsAsBody: true,
                                  params: params).eraseToAnyPublisher()
    }
}
