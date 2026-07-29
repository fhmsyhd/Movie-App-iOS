import Foundation

enum MovieMapper {
    static func toDomain(_ dto: MovieDTO, isFavorite: Bool = false) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate ?? "",
            voteAverage: dto.voteAverage,
            isFavorite: isFavorite
        )
    }

    static func toDomain(_ dto: MovieDetailDTO, isFavorite: Bool = false) -> MovieDetail {
        MovieDetail(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate ?? "",
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount,
            runtime: dto.runtime ?? 0,
            genres: dto.genres.map { Genre(id: $0.id, name: $0.name) },
            tagline: dto.tagline ?? "",
            isFavorite: isFavorite
        )
    }

    static func toDTO(_ movie: Movie) -> MovieDTO {
        MovieDTO(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage
        )
    }
}
