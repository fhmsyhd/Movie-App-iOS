import Combine

public protocol GetMovieDetailUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<MovieDetail, MovieError>
}

public final class GetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: Int) -> AnyPublisher<MovieDetail, MovieError> {
        repository.fetchMovieDetail(id: id)
    }
}
