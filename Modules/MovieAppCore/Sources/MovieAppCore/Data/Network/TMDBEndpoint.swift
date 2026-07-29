import Foundation

public enum TMDBConfiguration {
    public static var secretsPlistName = "Secrets"

    public static var apiKey: String = {
        guard
            let url = Bundle.main.url(forResource: secretsPlistName, withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
            let key = plist["TMDB_API_KEY"] as? String,
            !key.isEmpty
        else {
            assertionFailure("Missing TMDB_API_KEY in \(secretsPlistName).plist")
            return ""
        }
        return key
    }()
}

public enum TMDBEndpoint {
    public static let baseURL = "https://api.themoviedb.org/3"

    case popular(page: Int)
    case topRated(page: Int)
    case search(query: String, page: Int)
    case detail(id: Int)

    public var url: URL? {
        var components: URLComponents

        switch self {
        case .popular(let page):
            components = URLComponents(string: "\(TMDBEndpoint.baseURL)/movie/popular")!
            components.queryItems = [.init(name: "page", value: "\(page)")]
        case .topRated(let page):
            components = URLComponents(string: "\(TMDBEndpoint.baseURL)/movie/top_rated")!
            components.queryItems = [.init(name: "page", value: "\(page)")]
        case .search(let query, let page):
            components = URLComponents(string: "\(TMDBEndpoint.baseURL)/search/movie")!
            components.queryItems = [
                .init(name: "query", value: query),
                .init(name: "page", value: "\(page)")
            ]
        case .detail(let id):
            components = URLComponents(string: "\(TMDBEndpoint.baseURL)/movie/\(id)")!
            components.queryItems = []
        }

        components.queryItems?.append(.init(name: "api_key", value: TMDBConfiguration.apiKey))
        components.queryItems?.append(.init(name: "language", value: "en-US"))
        return components.url
    }
}
