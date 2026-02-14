//
//  CategoryView.swift
//  Landmarks
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    @Environment(\.landmarkService) private var landmarkService
    @State private var landmarks: [Landmark] = []

    var body: some View {
        List(landmarks) { landmark in
            NavigationLink(screen: .landmarks(.detail(landmark))) {
                LandmarkRow(landmark: landmark)
            }
        }
        .navigationTitle(category.rawValue)
        .toolbar(.hidden, for: .tabBar)
        .task {
            landmarks = (try? await landmarkService.fetchLandmarksByCategory(category)) ?? []
        }
    }
}

#Preview {
    NavigationStack {
        CategoryView(category: .mountains)
    }
    .services(.preview)
}
