import Foundation
import Combine
import MovieAppCore

public final class FavoriteViewModel: ObservableObject {
    @Published public var movies: [Movie] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private let favoriteBroadcaster: FavoriteStatusBroadcasting
    private var cancellables = Set<AnyCancellable>()

    public init(
        getFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol,
        favoriteBroadcaster: FavoriteStatusBroadcasting = FavoriteStatusCenter.shared
    ) {
        self.getFavoriteMoviesUseCase = getFavoriteMoviesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.favoriteBroadcaster = favoriteBroadcaster

        observeFavoriteChanges()
    }

    private func observeFavoriteChanges() {
        favoriteBroadcaster.changes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let self else { return }
                if !change.isFavorite {
                    self.movies.removeAll { $0.id == change.movieId }
                }
            }
            .store(in: &cancellables)
    }

    public func loadFavorites() {
        isLoading = true
        errorMessage = nil

        getFavoriteMoviesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }

    public func removeFavorite(_ movie: Movie) {
        toggleFavoriteUseCase.execute(movie: movie, isCurrentlyFavorite: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { _ in
                // No local mutation here on purpose — observeFavoriteChanges()
                // removes the row once the broadcaster fires, for every
                // screen including this one.
            }
            .store(in: &cancellables)
    }
}
