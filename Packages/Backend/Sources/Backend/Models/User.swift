import Foundation

public struct User: Codable, Identifiable {
    public let id: String
    public let name: String
    public let createdUtc: Date?
    public let iconImg: String?
    public var avatarURL: URL? {
        if let stringUrl = iconImg,
           let index = stringUrl.firstIndex(of: "?"),
           let url = URL(string: String(stringUrl.prefix(upTo: index))) {
            return url
        }
        return nil
    }
    public let linkKarma: Int
    public let commentKarma: Int
}

public let static_user = User(id: "0", name: "Test user", createdUtc: Date(), iconImg: nil, linkKarma: 12000, commentKarma: 200)
