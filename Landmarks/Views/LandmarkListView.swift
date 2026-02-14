//
//  LandmarkListView.swift
//  Landmarks
//

import SwiftUI

struct LandmarkListView: View {
    @Environment(\.landmarkService) private var landmarkService

    /// Views observe the store directly - the single source of truth.
    private var store: LandmarkStore { landmarkService.store }

    var body: some View {
        Group {
            switch store.loadingState {
            case .idle, .loading:
                ProgressView("Loading landmarks...")
            case .failed(let error):
                ContentUnavailableView(
                    "Unable to Load",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error.localizedDescription)
                )
            case .loaded:
                landmarksList
            }
        }
        .navigationTitle("Landmarks")
        .overlay {
            if store.isShowingCachedData {
                VStack {
                    Spacer()
                    Label("Showing cached data", systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 8)
                }
            }
        }
        .task {
            do {
                try await landmarkService.fetchLandmarks(.cacheThenFetch)
            } catch {
                // Network failed - fall back to cache only
                try? await landmarkService.fetchLandmarks(.cacheOnly)
            }
        }
    }

    private var landmarksList: some View {
        List {
            // Featured Section
            if !store.featuredLandmarks.isEmpty {
                Section("Featured") {
                    ForEach(store.featuredLandmarks) { landmark in
                        NavigationLink(screen: .landmarks(.detail(landmark))) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
            }

            // Categories Section
            Section("Categories") {
                ForEach(Category.allCases) { category in
                    NavigationLink(screen: .landmarks(.category(category))) {
                        Label(category.rawValue, systemImage: category.systemImage)
                    }
                }
            }

            // All Landmarks Section
            Section("All Landmarks") {
                ForEach(store.landmarks) { landmark in
                    NavigationLink(screen: .landmarks(.detail(landmark))) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkListView()
    }
    .services(.preview)
}
