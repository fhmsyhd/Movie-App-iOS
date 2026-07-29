import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movie == nil {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.movie == nil {
                ErrorStateView(message: errorMessage) {
                    viewModel.loadDetail()
                }
            } else if let movie = viewModel.movie {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        backdrop(for: movie)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                poster(for: movie)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(movie.title)
                                        .font(.title2.bold())
                                        .fixedSize(horizontal: false, vertical: true)

                                    if !movie.tagline.isEmpty {
                                        Text(movie.tagline)
                                            .font(.subheadline)
                                            .italic()
                                            .foregroundStyle(.secondary)
                                    }

                                    Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(.yellow)

                                    Text("\(movie.voteCount) votes")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            HStack(spacing: 16) {
                                metaChip(icon: "calendar", text: movie.releaseDate)
                                if movie.runtime > 0 {
                                    metaChip(icon: "clock", text: movie.runtimeFormatted)
                                }
                            }

                            if !movie.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(movie.genres) { genre in
                                            Text(genre.name)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.accentColor.opacity(0.15))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }

                            Divider()

                            Text("Overview")
                                .font(.headline)
                            Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(movie.isFavorite ? .red : .primary)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.movie == nil {
                viewModel.loadDetail()
            }
        }
    }

    @ViewBuilder
    private func backdrop(for movie: MovieDetail) -> some View {
        CachedAsyncImage(url: movie.backdropURL ?? movie.posterURL) { image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle().fill(Color.secondary.opacity(0.15))
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    @ViewBuilder
    private func poster(for movie: MovieDetail) -> some View {
        CachedAsyncImage(url: movie.posterURL) { image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle().fill(Color.secondary.opacity(0.15))
        }
        .frame(width: 100, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4, y: 2)
        .offset(y: -40)
        .padding(.bottom, -40)
    }

    private func metaChip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
