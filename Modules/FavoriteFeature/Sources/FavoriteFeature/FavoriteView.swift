import SwiftUI
import MovieAppCore
import CommonUI
import DetailFeature

public struct FavoriteView: View {
    @ObservedObject var viewModel: FavoriteViewModel
    let makeDetailViewModel: (Int) -> DetailViewModel

    public init(viewModel: FavoriteViewModel, makeDetailViewModel: @escaping (Int) -> DetailViewModel) {
        self.viewModel = viewModel
        self.makeDetailViewModel = makeDetailViewModel
    }

    public var body: some View {
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
            DetailView(viewModel: makeDetailViewModel(movieId))
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
