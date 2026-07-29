import Foundation

enum TMDBEndpoint {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "9109b2a2aa9336ea2595ace2f8ea18c0"

    case popular(page: Int)
    case topRated(page: Int)
    case search(query: String, page: Int)
    case detail(id: Int)

    var url: URL? {
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

        components.queryItems?.append(.init(name: "api_key", value: TMDBEndpoint.apiKey))
        components.queryItems?.append(.init(name: "language", value: "en-US"))
        return components.url
    }
}
