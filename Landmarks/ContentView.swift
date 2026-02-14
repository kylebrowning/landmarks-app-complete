//
//  ContentView.swift
//  Landmarks
//

import SwiftUI

struct ContentView: View {
    @Environment(\.landmarkService) private var landmarkService
    @State private var navigator = Navigator()

    var body: some View {
        @Bindable var navigator = navigator

        TabView(selection: $navigator.selectedTab) {
            NavigationStack(path: $navigator.landmarksPath) {
                LandmarkListView()
                    .screenDestination(path: $navigator.landmarksPath)
            }
            .tabItem { Label("Landmarks", systemImage: "map") }
            .tag(Navigator.Tab.landmarks)

            NavigationStack(path: $navigator.favoritesPath) {
                FavoritesView()
                    .screenDestination(path: $navigator.favoritesPath)
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
            .tag(Navigator.Tab.favorites)

            NavigationStack(path: $navigator.deepLinksPath) {
                DeepLinksView()
                    .screenDestination(path: $navigator.deepLinksPath)
            }
            .tabItem { Label("Deep Links", systemImage: "link") }
            .tag(Navigator.Tab.deepLinks)
        }
        .environment(navigator)
        .onOpenURL { url in
            navigator.handleDeepLink(url)
        }
        .onAppear {
            navigator.loadState()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            navigator.saveState()
        }
    }
}

#Preview {
    ContentView()
        .services(.preview)
}
