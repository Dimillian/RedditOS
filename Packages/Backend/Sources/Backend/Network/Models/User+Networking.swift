//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 24/07/2020.
//

import Foundation
import Combine

extension User {
    static public func fetchMe() -> AnyPublisher<User, NetworkError>? {
        API.shared.request(endpoint: .me).eraseToAnyPublisher()
    }
    
    static public func fetchUserAbout(username: String) -> AnyPublisher<ListingHolder<User>, NetworkError>? {
        API.shared.request(endpoint: .userAbout(username: username)).eraseToAnyPublisher()
    }
    
    public func fetchOverview(after: String?) -> AnyPublisher<ListingResponse<GenericListingContent>, Never> {
        var params: [String: String] = ["limit" : "100"]
        if let after = after {
            params["after"] = after
        }
        return API.shared.request(endpoint: .userOverview(usernmame: name),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
    
    public func fetchSaved(after: SubredditPost?) -> AnyPublisher<ListingResponse<SubredditPost>, Never> {
        var params: [String: String] = ["type": "links"]
        if let listing = after {
            params["after"] = listing.name
        }
        return API.shared.request(endpoint: .userSaved(username: name),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
    
    public func fetchSubmitted(after: SubredditPost?) -> AnyPublisher<ListingResponse<SubredditPost>, Never> {
        var params: [String: String] = [:]
        if let listing = after {
            params["after"] = listing.name
        }
        return API.shared.request(endpoint: .userSubmitted(username: name),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
    
    public func fetchComments(after: Comment?) -> AnyPublisher<ListingResponse<Comment>, Never> {
        var params: [String: String] = [:]
        if let listing = after {
            params["after"] = listing.name
        }
        return API.shared.request(endpoint: .userComments(username: name),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
}
