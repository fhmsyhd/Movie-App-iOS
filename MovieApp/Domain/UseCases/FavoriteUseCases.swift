import Combine

protocol GetFavoriteMoviesUseCaseProtocol {
    func execute() -> AnyPublisher<[Movie], MovieError>
}

protocol ToggleFavoriteUseCaseProtocol {
    func execute(movie: Movie, isCurrentlyFavorite: Bool) -> AnyPublisher<Void, MovieError>
}

protocol IsFavoriteUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

final class GetFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    init(repository: MovieRepositoryProtocol) { self.repository = repository }

    func execute() -> AnyPublisher<[Movie], MovieError> {
        repository.fetchFavoriteMovies()
    }
}

final class ToggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    init(repository: MovieRepositoryProtocol) { self.repository = repository }

    func execute(movie: Movie, isCurrentlyFavorite: Bool) -> AnyPublisher<Void, MovieError> {
        isCurrentlyFavorite
            ? repository.removeFavorite(id: movie.id)
            : repository.addFavorite(movie)
    }
}

final class IsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    init(repository: MovieRepositoryProtocol) { self.repository = repository }

    func execute(id: Int) -> AnyPublisher<Bool, Never> {
        repository.isFavorite(id: id)
    }
}
