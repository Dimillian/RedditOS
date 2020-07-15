import Foundation

public struct ListingResponse<T: Decodable>: Decodable {
    public let kind: String?
    public let data: ListingData<T>?
    public let errorMessage: String?
    
    public init(error: String) {
        self.errorMessage = error
        self.kind = nil
        self.data = nil
    }
}

public struct ListingData<T: Decodable>: Decodable {
    public let modhash: String?
    public let dist: Int?
    public let after: String?
    public let before: String?
    public let children: [ListingHolder<T>]
}

public struct ListingHolder<T: Decodable>: Decodable {
    public let kind: String
    public let data: T
}

