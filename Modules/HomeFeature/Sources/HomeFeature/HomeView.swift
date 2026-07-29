import SwiftUI
import MovieAppCore
import CommonUI
import DetailFeature

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let makeDetailViewModel: (Int) -> DetailViewModel

    public init(viewModel: HomeViewModel, makeDetailViewModel: @escaping (Int) -> DetailViewModel) {
        self.viewModel = viewModel
        self.makeDetailViewModel = makeDetailViewModel
    }

    public var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.movies.isEmpty {
                ErrorStateView(message: errorMessage) {
                    viewModel.loadPopularMovies()
                }
            } else if viewModel.movies.isEmpty {
                EmptyStateView(
                    systemImage: "magnifyingglass",
                    title: "No Results",
                    message: "Try a different search term."
                )
            } else {
                List(viewModel.movies) { movie in
                    NavigationLink(value: movie.id) {
                        MovieRowView(movie: movie) {
                            viewModel.toggleFavorite(movie)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Popular Movies")
        .navigationDestination(for: Int.self) { movieId in
            DetailView(viewModel: makeDetailViewModel(movieId))
        }
        .searchable(text: $viewModel.searchText, prompt: "Search movies")
        .onAppear {
            if viewModel.movies.isEmpty {
                viewModel.loadPopularMovies()
            }
        }
    }
}
