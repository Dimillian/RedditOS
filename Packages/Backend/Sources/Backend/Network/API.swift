import Foundation
import Combine

public class API {
    static public let shared = API()
    static public let BASE_URL = URL(string: "https://www.reddit.com")!
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["User-Agent": "macOS:RedditOS:v1.0 (by /u/Dimillian)"]
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        session = URLSession(configuration: configuration)
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    public static func makeURL(endpoint: Endpoint) -> URL {
        let component = URLComponents(url: Self.BASE_URL
                                        .appendingPathComponent(endpoint.path())
                                        .appendingPathExtension("json"),
                                      resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    public func fetch<T: Decodable>(endpoint: Endpoint,
                                    httpMethod: String = "GET",
                                    params: [String: String]? = nil) -> AnyPublisher<T ,APIError> {
        var url = Self.makeURL(endpoint: endpoint)
        if let params = params {
            for (_, value) in params.enumerated() {
                url = url.appending(value.key, value: value.value)
            }
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return session.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError{ error in
                APIError.parseError(reason: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
