import Foundation
import Combine

public class API {
    static public let shared = API()
    static private let URL_PREFIX = "https://"
    static private let HOST = "reddit.com"
    static private let HOST_AUTH_DOMAIN = "oauth"
    
    @Published private var authenticatedSession: URLSession?
    private var signedOutSession: URLSession
    private let decoder: JSONDecoder
    
    private var oauthStateCancellable: AnyCancellable?
        
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        signedOutSession = URLSession(configuration: Self.makeSessionConfiguration(token: nil))
        oauthStateCancellable = OauthClient.shared.$authState.sink { state in
            DispatchQueue.main.async {
                switch state {
                case .authenthicated(let token):
                    self.authenticatedSession = URLSession(configuration: Self.makeSessionConfiguration(token: token))
                case .refreshing, .signinInProgress, .signedOut:
                    self.authenticatedSession = nil
                }
            }
        }
    }
    
    static private func makeSessionConfiguration(token: String?) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        var headers = ["User-Agent": "macOS:RedditOS:v1.0 (by /u/Dimillian)"]
        if let token = token {
            headers["Authorization"] = "bearer \(token)"
        }
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        return configuration
    }
    
    static private func makeURL(endpoint: Endpoint,
                                basicAuthUser: String?,
                                forceSignedOutURL: Bool,
                                isJSONAPI: Bool) -> URL {
        var url: URL
        if let user = basicAuthUser {
            url = URL(string: "\(Self.URL_PREFIX)\(user):@www.\(Self.HOST)")!
        } else {
            if forceSignedOutURL {
                url = URL(string: "\(Self.URL_PREFIX)www.\(Self.HOST)")!
            } else {
                switch OauthClient.shared.authState {
                case .authenthicated:
                    url = URL(string: "\(Self.URL_PREFIX)\(Self.HOST_AUTH_DOMAIN).\(Self.HOST)")!
                default:
                    url = URL(string: "\(Self.URL_PREFIX)www.\(Self.HOST)")!
                }
            }
        }
        url = url.appendingPathComponent(endpoint.path())
        if isJSONAPI {
            url = url.appendingPathExtension("json")
        }
        let component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    static private func makeRequest(url: URL,
                             httpMethod: String = "GET",
                             queryParamsAsBody: Bool,
                             params: [String: String]? = nil) -> URLRequest {
        var request: URLRequest
        var url = url
        if let params = params {
            if queryParamsAsBody {
                var urlComponents = URLComponents()
                urlComponents.queryItems = []
                for (_, param) in params.enumerated() {
                    urlComponents.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
                }
                request = URLRequest(url: url)
                request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
                request.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
            } else {
                for (_, value) in params.enumerated() {
                    url = url.appending(value.key, value: value.value)
                }
                request = URLRequest(url: url)
            }
        } else {
            request = URLRequest(url: url)
        }
        request.httpMethod = httpMethod
        return request
    }
    
    public func request<T: Decodable>(endpoint: Endpoint,
                                      basicAuthUser: String? = nil,
                                      forceSignedOutURL: Bool = false,
                                      httpMethod: String = "GET",
                                      isJSONEndpoint: Bool = true,
                                      queryParamsAsBody: Bool = false,
                                      params: [String: String]? = nil) -> AnyPublisher<T ,NetworkError> {
    
        if basicAuthUser != nil || authenticatedSession != nil ||
            OauthClient.shared.authState == .signedOut || OauthClient.shared.authState == .signinInProgress {
            let url = Self.makeURL(endpoint: endpoint,
                                   basicAuthUser: basicAuthUser,
                                   forceSignedOutURL: forceSignedOutURL,
                                   isJSONAPI: isJSONEndpoint)
            let request = Self.makeRequest(url: url,
                                           httpMethod: httpMethod,
                                           queryParamsAsBody: queryParamsAsBody,
                                           params: params)
            
            if let session = authenticatedSession, !forceSignedOutURL {
                return executeRequest(publisher: session.dataTaskPublisher(for: request))
            } else {
                return executeRequest(publisher: signedOutSession.dataTaskPublisher(for: request))
            }
        } else {
            return $authenticatedSession
                .compactMap{ $0 }
                .map {
                    $0.dataTaskPublisher(for: Self.makeRequest(url: Self.makeURL(endpoint: endpoint,
                                                                                 basicAuthUser: basicAuthUser,
                                                                                 forceSignedOutURL: forceSignedOutURL,
                                                                                 isJSONAPI: isJSONEndpoint),
                                                               httpMethod: httpMethod,
                                                               queryParamsAsBody: queryParamsAsBody,
                                                               params: params))
                    }
                .flatMap { self.executeRequest(publisher: $0) }
                .eraseToAnyPublisher()
        }
    }
    
    public func POST(endpoint: Endpoint,
                     isJSONEndpoint: Bool = true,
                     params: [String: String]? = nil) -> AnyPublisher<NetworkResponse, Never> {
        request(endpoint: endpoint,
                httpMethod: "POST",
                isJSONEndpoint: isJSONEndpoint,
                queryParamsAsBody: true,
                params: params)
            .subscribe(on: DispatchQueue.global())
            .catch { Just(NetworkResponse(error: RedditError.processNetworkError(error: $0))) }
            .eraseToAnyPublisher()
    }
        
    private func executeRequest<T: Decodable>(publisher: URLSession.DataTaskPublisher) -> AnyPublisher<T ,NetworkError> {
        publisher
        .tryMap{ data, response in
            return try NetworkError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: decoder)
        .mapError{ error in
            print("----- BEGIN PARSING ERROR-----")
            print(error)
            print("----- END PARSING ERROR-----")
            return NetworkError.parseError(reason: error)
        }
        .eraseToAnyPublisher()
    }
}
