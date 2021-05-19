import Foundation
import SwiftUI

public class LocalDataStore: ObservableObject, PersistentDataStore {
    public static let shared = LocalDataStore()
    
    @Published public private(set) var favorites: [SubredditSmall] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published public private(set) var recentlyVisited: [SubredditSmall] = [] {
        didSet {
            saveData()
        }
    }
    
    let persistedDataFilename = "redditOsData"
    typealias DataType = SavedData
    
    struct SavedData: Codable {
        let favorites: [SubredditSmall]
        let recentlyVisited: [SubredditSmall]?
    }
    
    public init() {
        let data = restorePersistedData()
        var favorites = data?.favorites ?? []
        favorites.sort{ $0.name.lowercased() < $1.name.lowercased() }
        self.favorites = favorites
        self.recentlyVisited = data?.recentlyVisited ?? []
    }
    
    // MARK: - Favorites management
    public func add(favorite: SubredditSmall) {
        if !favorites.contains(favorite) {
            favorites.append(favorite)
        }
    }
    
    public func add(recent: SubredditSmall) {
        guard !recentlyVisited.contains(recent) else {
            return
        }
        var edit = recentlyVisited
        edit.insert(recent, at: 0)
        if edit.count > 5 {
            edit.removeLast()
        }
        recentlyVisited = edit
    }
    
    public func remove(favorite: SubredditSmall) {
        favorites.removeAll(where: { $0 == favorite })
    }
    
    public func remove(favoriteNamed: String) {
        favorites.removeAll(where: { $0.name == favoriteNamed })
    }
    
    // MARK: - Private
    
    private func saveData() {
        persistData(data: SavedData(favorites: favorites, recentlyVisited: recentlyVisited))
    }
}
