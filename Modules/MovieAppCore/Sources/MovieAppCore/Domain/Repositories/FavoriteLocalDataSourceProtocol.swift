import Foundation
import Combine

public protocol FavoriteLocalDataSourceProtocol {
    func fetchFavorites() -> AnyPublisher<[MovieDTO], MovieError>
    func isFavorite(id: Int) -> AnyPublisher<Bool, Never>
    func addFavorite(_ movie: MovieDTO) -> AnyPublisher<Void, MovieError>
    func removeFavorite(id: Int) -> AnyPublisher<Void, MovieError>
}
