import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    @Published var movie: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    let movieId: Int
    private let getMovieDetailUseCase: GetMovieDetailUseCaseProtocol
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        movieId: Int,
        getMovieDetailUseCase: GetMovieDetailUseCaseProtocol,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    ) {
        self.movieId = movieId
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func loadDetail() {
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

    func toggleFavorite() {
        guard let movie else { return }
        toggleFavoriteUseCase.execute(movie: movie.asMovie(), isCurrentlyFavorite: movie.isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                }
            } receiveValue: { [weak self] _ in
                self?.movie?.isFavorite.toggle()
            }
            .store(in: &cancellables)
    }
}
