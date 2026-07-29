import Foundation

public struct MovieDetailDTO: Decodable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String?
    public let voteAverage: Double
    public let voteCount: Int
    public let runtime: Int?
    public let genres: [GenreDTO]
    public let tagline: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, tagline, runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public struct GenreDTO: Decodable {
    public let id: Int
    public let name: String
}
