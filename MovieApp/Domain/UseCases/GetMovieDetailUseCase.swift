import Combine

protocol GetMovieDetailUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<MovieDetail, MovieError>
}

final class GetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<MovieDetail, MovieError> {
        repository.fetchMovieDetail(id: id)
    }
}
