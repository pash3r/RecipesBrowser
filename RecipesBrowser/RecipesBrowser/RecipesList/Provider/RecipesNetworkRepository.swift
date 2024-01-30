//
//  RecipesNetworkRepository.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

final class RecipesNetworkRepository: RecipesRepositoryDescription {
    private let networkClient: NetworkClient
    private let decoder: JSONDecoder = JSONDecoder()
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    @MainActor
    func getRecipes() async throws -> [Meal] {
        do {
            let (data, response) = try await networkClient.load(url: makeListUrl())
            return try await handle(data: data, response: response)
        } catch {
            throw RepositoryError.networkError(error)
        }
    }
    
    func getRecipe(with id: String) async throws -> Meal {
        Meal.preview.first!
    }
    
    private func makeListUrl() -> URL {
        var components = makeUrlComponents()
        let queryItem = URLQueryItem(name: Constants.categoryFilterParamName, value: Constants.categoryName)
        components.queryItems = [queryItem]
        
        guard let result = components.url else {
            fatalError("failed to create recipes URL from components: \(components)")
        }
        
        return result
    }
    
    private func makeUrlComponents() -> URLComponents {
        guard let urlComponents = URLComponents(url: Constants.baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("fatal error: Failed to create URL components for recipes list request")
        }
        
        return urlComponents
    }
    
    private func handle(data: Data, response: URLResponse) async throws -> [Meal] {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RepositoryError.generalError
        }
        
        let statusCode = httpResponse.statusCode
        guard (0...200).contains(statusCode) else {
            throw RepositoryError.badResponseCode(statusCode)
        }
        
        let dataString = String(data: data, encoding: .utf8)
        
        do {
            let result = try decoder.decode(RecipesListResponse.self, from: data)
            return result.meals
        } catch {
            throw RepositoryError.decodingError(error)
        }
    }
    
    private struct Constants {
        static let baseUrl: URL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php")!
        static let categoryFilterParamName: String = "c"
        static let categoryName = "Dessert"
    }
    
    enum RepositoryError: Error {
        case networkError(Error)
        case badResponseCode(Int)
        case generalError
        case decodingError(Error)
    }
}

struct RecipesListResponse: Decodable {
    let meals: [Meal]
}

final class NetworkClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func load(url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}
