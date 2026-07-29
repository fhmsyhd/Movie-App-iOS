import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    private let getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    init(
        getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol,
        searchMoviesUseCase: SearchMoviesUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    ) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase

        observeSearchText()
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

    func loadPopularMovies() {
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

    func toggleFavorite(_ movie: Movie) {
        toggleFavoriteUseCase.execute(movie: movie, isCurrentlyFavorite: movie.isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] _ in
                self?.flipLocalFavoriteFlag(for: movie.id)
            }
            .store(in: &cancellables)
    }

    private func flipLocalFavoriteFlag(for id: Int) {
        guard let index = movies.firstIndex(where: { $0.id == id }) else { return }
        movies[index].isFavorite.toggle()
    }
}
