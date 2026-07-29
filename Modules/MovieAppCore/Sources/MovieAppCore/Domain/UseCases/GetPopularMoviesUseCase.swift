import Combine

public protocol GetPopularMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[Movie], MovieError>
}

public final class GetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int = 1) -> AnyPublisher<[Movie], MovieError> {
        repository.fetchPopularMovies(page: page)
    }
}
