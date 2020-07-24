//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 24/07/2020.
//

import Foundation

fileprivate let decoder = JSONDecoder()
fileprivate let encoder = JSONEncoder()
fileprivate let saving_queue = DispatchQueue(label: "redditOS.savingqueue", qos: .background)

protocol PersistentDataStore {
    associatedtype DataType: Codable
    var persistedDataFilename: String { get }
    func persistData(data: DataType)
    func restorePersistedData() -> DataType?
}

extension PersistentDataStore {
    func persistData(data: DataType) {
        saving_queue.async {
            do {
                let filePath = try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
                    .appendingPathComponent(persistedDataFilename)
                let archive = try encoder.encode(data)
                try archive.write(to: filePath, options: .atomicWrite)
            } catch let error {
                print("Error while saving: \(error.localizedDescription)")
            }
        }
    }
    
    func restorePersistedData() -> DataType? {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
                .appendingPathComponent(persistedDataFilename)
            if let data = try? Data(contentsOf: filePath) {
                return try decoder.decode(DataType.self, from: data)
            }
        } catch let error {
            print("Error while loading: \(error.localizedDescription)")
        }
        return nil
    }
}
