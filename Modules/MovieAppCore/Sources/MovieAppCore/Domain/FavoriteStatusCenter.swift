import Combine

public struct FavoriteChange: Equatable {
    public let movieId: Int
    public let isFavorite: Bool

    public init(movieId: Int, isFavorite: Bool) {
        self.movieId = movieId
        self.isFavorite = isFavorite
    }
}

public protocol FavoriteStatusBroadcasting {
    var changes: AnyPublisher<FavoriteChange, Never> { get }
    func notify(_ change: FavoriteChange)
}

public final class FavoriteStatusCenter: FavoriteStatusBroadcasting {
    public static let shared = FavoriteStatusCenter()

    private let subject = PassthroughSubject<FavoriteChange, Never>()

    public var changes: AnyPublisher<FavoriteChange, Never> {
        subject.eraseToAnyPublisher()
    }

    public init() {}

    public func notify(_ change: FavoriteChange) {
        subject.send(change)
    }
}
