//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import Foundation
import SwiftUI

public class PersistedContent: ObservableObject {
    @Published public var favorites: [SubredditSmall] = [] {
        didSet {
            save()
        }
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    struct SavedData: Codable {
        let favorites: [SubredditSmall]
    }
    
    public init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("redditOsData")
            load()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func load() {
        if let data = try? Data(contentsOf: filePath) {
            do {
                let savedData = try decoder.decode(SavedData.self, from: data)
                self.favorites = savedData.favorites.sorted{ $0.name.lowercased() < $1.name.lowercased() }
            } catch let error {
                print("Error while loading: \(error.localizedDescription)")
            }
        }
    }
    
    private func save() {
        do {
            let savedData = SavedData(favorites: favorites)
            let data = try self.encoder.encode(savedData)
            try data.write(to: self.filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving: \(error.localizedDescription)")
        }
    }
}
