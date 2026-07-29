import Foundation
import Combine
import MovieAppCore

public final class HomeViewModel: ObservableObject {
    @Published public var movies: [Movie] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var searchText: String = ""

    private let getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private let favoriteBroadcaster: FavoriteStatusBroadcasting

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    public init(
        getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol,
        searchMoviesUseCase: SearchMoviesUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol,
        favoriteBroadcaster: FavoriteStatusBroadcasting = FavoriteStatusCenter.shared
    ) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.favoriteBroadcaster = favoriteBroadcaster

        observeSearchText()
        observeFavoriteChanges()
    }

    private func observeFavoriteChanges() {
        favoriteBroadcaster.changes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let self, let index = self.movies.firstIndex(where: { $0.id == change.movieId }) else { return }
                self.movies[index].isFavorite = change.isFavorite
            }
            .store(in: &cancellables)
    }

    private func observeSearchText() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.loadPopularMovies()
                } else {
                    self.search(query: query)
                }
            }
            .store(in: &cancellables)
    }

    public func loadPopularMovies() {
        isLoading = true
        errorMessage = nil

        getPopularMoviesUseCase.execute(page: 1)
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

    private func search(query: String) {
        isLoading = true
        errorMessage = nil

        searchCancellable = searchMoviesUseCase.execute(query: query, page: 1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
    }

    public func toggleFavorite(_ movie: Movie) {
        toggleFavoriteUseCase.execute(movie: movie, isCurrentlyFavorite: movie.isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
