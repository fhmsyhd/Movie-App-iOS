import Foundation

struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let genres: [GenreDTO]
    let tagline: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, tagline, runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}
