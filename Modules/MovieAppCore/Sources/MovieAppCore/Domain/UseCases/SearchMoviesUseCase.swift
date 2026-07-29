import Combine

public protocol SearchMoviesUseCaseProtocol {
    func execute(query: String, page: Int) -> AnyPublisher<[Movie], MovieError>
}

public final class SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(query: String, page: Int = 1) -> AnyPublisher<[Movie], MovieError> {
        repository.searchMovies(query: query, page: page)
    }
}
