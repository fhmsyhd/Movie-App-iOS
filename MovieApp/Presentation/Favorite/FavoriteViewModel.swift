import Foundation
import Combine

final class FavoriteViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        getFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    ) {
        self.getFavoriteMoviesUseCase = getFavoriteMoviesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func loadFavorites() {
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

    func removeFavorite(_ movie: Movie) {
        toggleFavoriteUseCase.execute(movie: movie, isCurrentlyFavorite: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] _ in
                self?.movies.removeAll { $0.id == movie.id }
            }
            .store(in: &cancellables)
    }
}
