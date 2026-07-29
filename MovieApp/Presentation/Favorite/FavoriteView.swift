import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel: FavoriteViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.movies.isEmpty {
                ErrorStateView(message: errorMessage) {
                    viewModel.loadFavorites()
                }
            } else if viewModel.movies.isEmpty {
                EmptyStateView(
                    systemImage: "heart",
                    title: "No Favorites Yet",
                    message: "Movies you favorite from Home will show up here."
                )
            } else {
                List(viewModel.movies) { movie in
                    NavigationLink(value: movie.id) {
                        MovieRowView(movie: movie) {
                            viewModel.removeFavorite(movie)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .navigationDestination(for: Int.self) { movieId in
            DetailView(viewModel: DIContainer.shared.resolveDetailViewModel(movieId: movieId))
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
