import SwiftUI
import MovieAppCore

public struct MovieRowView: View {
    let movie: Movie
    let onToggleFavorite: () -> Void

    public init(movie: Movie, onToggleFavorite: @escaping () -> Void) {
        self.movie = movie
        self.onToggleFavorite = onToggleFavorite
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CachedAsyncImage(url: movie.posterURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.15))
                    ProgressView()
                }
            }
            .frame(width: 80, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)

                Text(movie.releaseYear)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(movie.isFavorite ? .red : .secondary)
                .font(.title3)
                .padding(8)
                .contentShape(Rectangle())
                .onTapGesture {
                    onToggleFavorite()
                }
        }
        .padding(.vertical, 6)
    }
}
