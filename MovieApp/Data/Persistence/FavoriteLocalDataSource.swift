import Foundation
import CoreData
import Combine
import MovieAppCore

final class FavoriteLocalDataSource: FavoriteLocalDataSourceProtocol {
    private let stack: CoreDataStack

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func fetchFavorites() -> AnyPublisher<[MovieDTO], MovieError> {
        Future { [weak self] promise in
            guard let self else { return }
            let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
            do {
                let entities = try self.stack.context.fetch(request)
                let dtos = entities.map { entity in
                    MovieDTO(
                        id: Int(entity.id),
                        title: entity.title ?? "",
                        overview: entity.overview ?? "",
                        posterPath: entity.posterPath,
                        backdropPath: entity.backdropPath,
                        releaseDate: entity.releaseDate,
                        voteAverage: entity.voteAverage
                    )
                }
                promise(.success(dtos))
            } catch {
                promise(.failure(.persistence(error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }

    func isFavorite(id: Int) -> AnyPublisher<Bool, Never> {
        Future { [weak self] promise in
            guard let self else { return promise(.success(false)) }
            let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            let count = (try? self.stack.context.count(for: request)) ?? 0
            promise(.success(count > 0))
        }.eraseToAnyPublisher()
    }

    func addFavorite(_ movie: MovieDTO) -> AnyPublisher<Void, MovieError> {
        Future { [weak self] promise in
            guard let self else { return }
            let entity = FavoriteMovieEntity(context: self.stack.context)
            entity.id = Int64(movie.id)
            entity.title = movie.title
            entity.overview = movie.overview
            entity.posterPath = movie.posterPath
            entity.backdropPath = movie.backdropPath
            entity.releaseDate = movie.releaseDate
            entity.voteAverage = movie.voteAverage
            entity.addedAt = Date()
            self.stack.saveContext()
            promise(.success(()))
        }.eraseToAnyPublisher()
    }

    func removeFavorite(id: Int) -> AnyPublisher<Void, MovieError> {
        Future { [weak self] promise in
            guard let self else { return }
            let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                let results = try self.stack.context.fetch(request)
                results.forEach { self.stack.context.delete($0) }
                self.stack.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(.persistence(error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
}
