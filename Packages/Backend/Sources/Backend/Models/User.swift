import Foundation

public struct User: Codable, Identifiable {
    public let id: String
    public let name: String
    public let createdUTC: Date?
    public let iconImg: URL?
    public let linkKarma: Int
    public let commentKarma: Int
}
