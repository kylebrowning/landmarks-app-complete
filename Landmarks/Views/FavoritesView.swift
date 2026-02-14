//
//  FavoritesView.swift
//  Landmarks
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.landmarkService) private var landmarkService

    /// Views observe the store directly.
    private var store: LandmarkStore { landmarkService.store }

    var body: some View {
        Group {
            if store.featuredLandmarks.isEmpty {
                ContentUnavailableView(
                    "No Favorites",
                    systemImage: "heart.slash",
                    description: Text("Landmarks you favorite will appear here.")
                )
            } else {
                List(store.featuredLandmarks) { landmark in
                    NavigationLink(screen: .favorites(.detail(landmark))) {
                        LandmarkRow(landmark: landmark)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            Task {
                                try? await landmarkService.toggleFavorite(landmark)
                            }
                        } label: {
                            Label("Remove", systemImage: "heart.slash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
    .services(.preview)
}
