import SwiftUI
import HomeFeature
import FavoriteFeature
import AboutFeature

@main
struct MovieAppApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(
                    viewModel: DIContainer.shared.resolve(HomeViewModel.self),
                    makeDetailViewModel: { movieId in
                        DIContainer.shared.resolveDetailViewModel(movieId: movieId)
                    }
                )
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                FavoriteView(
                    viewModel: DIContainer.shared.resolve(FavoriteViewModel.self),
                    makeDetailViewModel: { movieId in
                        DIContainer.shared.resolveDetailViewModel(movieId: movieId)
                    }
                )
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }

            NavigationStack {
                AboutView()
            }
            .tabItem {
                Label("About", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(.accentColor)
    }
}
