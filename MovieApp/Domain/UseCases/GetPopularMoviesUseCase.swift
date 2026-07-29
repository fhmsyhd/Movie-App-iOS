import Combine

protocol GetPopularMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[Movie], MovieError>
}

final class GetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int = 1) -> AnyPublisher<[Movie], MovieError> {
        repository.fetchPopularMovies(page: page)
    }
}
