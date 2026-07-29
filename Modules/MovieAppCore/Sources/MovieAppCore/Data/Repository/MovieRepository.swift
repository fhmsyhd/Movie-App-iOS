import Foundation
import Combine

public final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let localDataSource: FavoriteLocalDataSourceProtocol

    public init(apiClient: APIClientProtocol, localDataSource: FavoriteLocalDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

    public func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], MovieError> {
        apiClient.request(.popular(page: page))
            .map { (page: MoviePageDTO) in page.results }
            .mapError { MovieError.network($0.localizedDescriptionText) }
            .flatMap { [weak self] dtos -> AnyPublisher<[Movie], MovieError> in
                self?.attachFavoriteStatus(dtos) ?? Just([]).setFailureType(to: MovieError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func fetchTopRatedMovies(page: Int) -> AnyPublisher<[Movie], MovieError> {
        apiClient.request(.topRated(page: page))
            .map { (page: MoviePageDTO) in page.results }
            .mapError { MovieError.network($0.localizedDescriptionText) }
            .flatMap { [weak self] dtos -> AnyPublisher<[Movie], MovieError> in
                self?.attachFavoriteStatus(dtos) ?? Just([]).setFailureType(to: MovieError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], MovieError> {
        apiClient.request(.search(query: query, page: page))
            .map { (page: MoviePageDTO) in page.results }
            .mapError { MovieError.network($0.localizedDescriptionText) }
            .flatMap { [weak self] dtos -> AnyPublisher<[Movie], MovieError> in
                self?.attachFavoriteStatus(dtos) ?? Just([]).setFailureType(to: MovieError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetail, MovieError> {
        apiClient.request(.detail(id: id))
            .mapError { MovieError.network($0.localizedDescriptionText) }
            .flatMap { [weak self] (dto: MovieDetailDTO) -> AnyPublisher<MovieDetail, MovieError> in
                guard let self else {
                    return Just(MovieMapper.toDomain(dto)).setFailureType(to: MovieError.self).eraseToAnyPublisher()
                }
                return self.localDataSource.isFavorite(id: id)
                    .setFailureType(to: MovieError.self)
                    .map { MovieMapper.toDomain(dto, isFavorite: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func fetchFavoriteMovies() -> AnyPublisher<[Movie], MovieError> {
        localDataSource.fetchFavorites()
            .map { dtos in dtos.map { MovieMapper.toDomain($0, isFavorite: true) } }
            .eraseToAnyPublisher()
    }

    public func isFavorite(id: Int) -> AnyPublisher<Bool, Never> {
        localDataSource.isFavorite(id: id)
    }

    public func addFavorite(_ movie: Movie) -> AnyPublisher<Void, MovieError> {
        localDataSource.addFavorite(MovieMapper.toDTO(movie))
    }

    public func removeFavorite(id: Int) -> AnyPublisher<Void, MovieError> {
        localDataSource.removeFavorite(id: id)
    }

    // MARK: - Private

    private func attachFavoriteStatus(_ dtos: [MovieDTO]) -> AnyPublisher<[Movie], MovieError> {
        guard !dtos.isEmpty else {
            return Just([]).setFailureType(to: MovieError.self).eraseToAnyPublisher()
        }
        let publishers = dtos.map { dto in
            localDataSource.isFavorite(id: dto.id)
                .map { MovieMapper.toDomain(dto, isFavorite: $0) }
        }
        return Publishers.MergeMany(publishers)
            .collect()
            .map { movies in
                let order = dtos.map(\.id)
                return movies.sorted { order.firstIndex(of: $0.id)! < order.firstIndex(of: $1.id)! }
            }
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
}

private extension NetworkError {
    var localizedDescriptionText: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let e): return e.localizedDescription
        case .invalidResponse: return "Invalid response"
        case .httpError(let code): return "HTTP \(code)"
        case .decodingFailed: return "Could not decode response"
        }
    }
}
