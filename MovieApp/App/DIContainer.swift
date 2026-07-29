import Swinject

final class DIContainer {
    static let shared = DIContainer()

    let container: Container

    private init() {
        container = Container()
        registerDataLayer()
        registerDomainLayer()
        registerPresentationLayer()
    }

    private func registerDataLayer() {
        container.register(APIClientProtocol.self) { _ in
            APIClient()
        }.inObjectScope(.container)

        container.register(FavoriteLocalDataSourceProtocol.self) { _ in
            FavoriteLocalDataSource()
        }.inObjectScope(.container)

        container.register(MovieRepositoryProtocol.self) { resolver in
            MovieRepository(
                apiClient: resolver.resolve(APIClientProtocol.self)!,
                localDataSource: resolver.resolve(FavoriteLocalDataSourceProtocol.self)!
            )
        }.inObjectScope(.container)
    }

    private func registerDomainLayer() {
        container.register(GetPopularMoviesUseCaseProtocol.self) { resolver in
            GetPopularMoviesUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        container.register(SearchMoviesUseCaseProtocol.self) { resolver in
            SearchMoviesUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        container.register(GetMovieDetailUseCaseProtocol.self) { resolver in
            GetMovieDetailUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        container.register(GetFavoriteMoviesUseCaseProtocol.self) { resolver in
            GetFavoriteMoviesUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        container.register(ToggleFavoriteUseCaseProtocol.self) { resolver in
            ToggleFavoriteUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
        container.register(IsFavoriteUseCaseProtocol.self) { resolver in
            IsFavoriteUseCase(repository: resolver.resolve(MovieRepositoryProtocol.self)!)
        }
    }

    private func registerPresentationLayer() {
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                getPopularMoviesUseCase: resolver.resolve(GetPopularMoviesUseCaseProtocol.self)!,
                searchMoviesUseCase: resolver.resolve(SearchMoviesUseCaseProtocol.self)!,
                toggleFavoriteUseCase: resolver.resolve(ToggleFavoriteUseCaseProtocol.self)!
            )
        }

        container.register(FavoriteViewModel.self) { resolver in
            FavoriteViewModel(
                getFavoriteMoviesUseCase: resolver.resolve(GetFavoriteMoviesUseCaseProtocol.self)!,
                toggleFavoriteUseCase: resolver.resolve(ToggleFavoriteUseCaseProtocol.self)!
            )
        }

        container.register(DetailViewModel.self) { (resolver, movieId: Int) in
            DetailViewModel(
                movieId: movieId,
                getMovieDetailUseCase: resolver.resolve(GetMovieDetailUseCaseProtocol.self)!,
                toggleFavoriteUseCase: resolver.resolve(ToggleFavoriteUseCaseProtocol.self)!
            )
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(type)!
    }

    func resolveDetailViewModel(movieId: Int) -> DetailViewModel {
        container.resolve(DetailViewModel.self, argument: movieId)!
    }
}
