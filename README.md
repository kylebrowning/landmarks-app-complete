# Building the Full Landmarks App

A complete SwiftUI app wired to a Vapor backend with navigation, caching, dependency injection, and network integration.

This is the companion project for the blog post: [Building the Full Landmarks App](https://kylebrowning.com/posts/building-the-full-landmarks-app)

## Overview

This project demonstrates:

- Full client-server integration with a Vapor backend
- Network client with closure-based API
- API model to domain model mapping at the boundary
- Tiered caching (memory + disk) with flexible fetch policies
- Closure-based dependency injection via SwiftUI environment
- Observable stores that views watch directly
- Type-safe navigation with enum-based screens
- Multiple service variants (live, mock, preview, unimplemented)

## Part of the Landmarks Series

This project is part of a [10-part series](https://kylebrowning.com/series/landmarks-app) on building a full-stack Swift app.

| # | Topic | Code |
|---|-------|------|
| 1 | [SwiftUI Navigation](https://kylebrowning.com/posts/swiftui-navigation-the-easy-way) | [Code](https://github.com/kylebrowning/swiftui-navigation-the-easy-way) |
| 2 | [Domain Models vs API Models](https://kylebrowning.com/posts/domain-models-vs-api-models) | [Code](https://github.com/kylebrowning/domain-models-vs-api-models) |
| 3 | [Dependency Injection](https://kylebrowning.com/posts/dependency-injection-in-swiftui) | [Code](https://github.com/kylebrowning/swift-dependency-injection) |
| 4 | [Tiered Caching](https://kylebrowning.com/posts/tiered-caching-in-swift) | [Code](https://github.com/kylebrowning/swift-caching) |
| 5 | [Vapor Backend](https://kylebrowning.com/posts/vapor-backend-for-landmarks) | [Code](https://github.com/kylebrowning/vapor-backend-for-landmarks) |
| **6** | **[Full Landmarks App](https://kylebrowning.com/posts/building-the-full-landmarks-app)** | **This repo** |
| 7 | [Deploy to AWS](https://kylebrowning.com/posts/deploying-vapor-to-aws) | [Code](https://github.com/kylebrowning/vapor-landmarks-deploy) |
| 8 | [Server Integration Testing](https://kylebrowning.com/posts/vapor-integration-testing) | [Code](https://github.com/kylebrowning/vapor-integration-testing) |
| 9 | [iOS App Testing](https://kylebrowning.com/posts/testing-landmarks-app) | [Code](https://github.com/kylebrowning/testing-landmarks-app) |
| 10 | [Maestro UI Testing](https://kylebrowning.com/posts/maestro-ui-testing) | [Code](https://github.com/kylebrowning/maestro-ui-testing) |

## License

MIT
