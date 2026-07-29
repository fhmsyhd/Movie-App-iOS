import Combine

protocol SearchMoviesUseCaseProtocol {
    func execute(query: String, page: Int) -> AnyPublisher<[Movie], MovieError>
}

final class SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String, page: Int = 1) -> AnyPublisher<[Movie], MovieError> {
        repository.searchMovies(query: query, page: page)
    }
}
