import Foundation
import Combine
import MovieAppCore

public final class DetailViewModel: ObservableObject {
    @Published public var movie: MovieDetail?
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    public let movieId: Int
    private let getMovieDetailUseCase: GetMovieDetailUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private let favoriteBroadcaster: FavoriteStatusBroadcasting
    private var cancellables = Set<AnyCancellable>()

    public init(
        movieId: Int,
        getMovieDetailUseCase: GetMovieDetailUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol,
        favoriteBroadcaster: FavoriteStatusBroadcasting = FavoriteStatusCenter.shared
    ) {
        self.movieId = movieId
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.favoriteBroadcaster = favoriteBroadcaster

        observeFavoriteChanges()
    }

    private func observeFavoriteChanges() {
        favoriteBroadcaster.changes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let self, change.movieId == self.movieId else { return }
                self.movie?.isFavorite = change.isFavorite
            }
            .store(in: &cancellables)
    }

    public func loadDetail() {
        isLoading = true
        errorMessage = nil

        getMovieDetailUseCase.execute(id: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] detail in
                self?.movie = detail
            }
            .store(in: &cancellables)
    }

    public func toggleFavorite() {
        guard let movie else { return }
        toggleFavoriteUseCase.execute(movie: movie.asMovie(), isCurrentlyFavorite: movie.isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { _ in
                // No local mutation here on purpose — observeFavoriteChanges()
                // updates `movie.isFavorite` from the broadcaster.
            }
            .store(in: &cancellables)
    }
}
