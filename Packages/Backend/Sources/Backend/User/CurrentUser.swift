import Foundation
import SwiftUI
import Combine

public class CurrentUser: ObservableObject {
    @Published public var user: User?
    @Published public var subscriptions: [Subreddit] = []
    
    private var disposables: [AnyCancellable?] = []
    
    private var authStateCancellable: AnyCancellable?
    
    public init() {
        authStateCancellable = OauthClient.shared.$authState.sink(receiveValue: { state in
            switch state {
            case .signedOut:
                self.user = nil
            case .authenthicated:
                self.refreshUser()
            default:
                break
            }
        })
    }
    
    private func refreshUser() {
        let cancellable = makeUserPublisher()?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { user in
                self.user = user
            })
        disposables.append(cancellable)
    }
    
    private func makeUserPublisher() -> AnyPublisher<User, APIError>? {
        return API.shared.request(endpoint: .me).eraseToAnyPublisher()
    }
}
