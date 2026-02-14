//
//  LandmarksApp.swift
//  Landmarks
//

import SwiftUI

@main
struct LandmarksApp: App {
    let services: Services

    init() {
        #if DEBUG
        let baseURL = URL(string: "http://localhost:8080")!
        #else
        let baseURL = URL(string: "https://api.yourapp.com")!
        #endif

        services = .live(baseURL: baseURL)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .services(services)
        }
    }
}
