import Combine

public protocol GetFavoriteMoviesUseCaseProtocol {
    func execute() -> AnyPublisher<[Movie], MovieError>
}

public protocol ToggleFavoriteUseCaseProtocol {
    func execute(movie: Movie, isCurrentlyFavorite: Bool) -> AnyPublisher<Void, MovieError>
}

public protocol IsFavoriteUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

public final class GetFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    public init(repository: MovieRepositoryProtocol) { self.repository = repository }

    public func execute() -> AnyPublisher<[Movie], MovieError> {
        repository.fetchFavoriteMovies()
    }
}

public final class ToggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    private let broadcaster: FavoriteStatusBroadcasting

    public init(
        repository: MovieRepositoryProtocol,
        broadcaster: FavoriteStatusBroadcasting = FavoriteStatusCenter.shared
    ) {
        self.repository = repository
        self.broadcaster = broadcaster
    }

    public func execute(movie: Movie, isCurrentlyFavorite: Bool) -> AnyPublisher<Void, MovieError> {
        let publisher = isCurrentlyFavorite
            ? repository.removeFavorite(id: movie.id)
            : repository.addFavorite(movie)

        return publisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.broadcaster.notify(
                    FavoriteChange(movieId: movie.id, isFavorite: !isCurrentlyFavorite)
                )
            })
            .eraseToAnyPublisher()
    }
}

public final class IsFavoriteUseCase: IsFavoriteUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    public init(repository: MovieRepositoryProtocol) { self.repository = repository }

    public func execute(id: Int) -> AnyPublisher<Bool, Never> {
        repository.isFavorite(id: id)
    }
}
