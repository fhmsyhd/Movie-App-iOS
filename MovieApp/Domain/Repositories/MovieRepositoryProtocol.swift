import Foundation
import Combine

protocol MovieRepositoryProtocol {
    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], MovieError>
    func fetchTopRatedMovies(page: Int) -> AnyPublisher<[Movie], MovieError>
    func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], MovieError>
    func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetail, MovieError>

    func fetchFavoriteMovies() -> AnyPublisher<[Movie], MovieError>
    func isFavorite(id: Int) -> AnyPublisher<Bool, Never>
    func addFavorite(_ movie: Movie) -> AnyPublisher<Void, MovieError>
    func removeFavorite(id: Int) -> AnyPublisher<Void, MovieError>
}

enum MovieError: Error, Equatable {
    case network(String)
    case decoding
    case persistence(String)
    case notFound
    case unknown

    var message: String {
        switch self {
        case .network(let msg): return "Network error: \(msg)"
        case .decoding: return "Failed to parse server response."
        case .persistence(let msg): return "Storage error: \(msg)"
        case .notFound: return "Movie not found."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
