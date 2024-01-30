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
            return try handle(data: data, response: response)
        } catch {
            throw RepositoryError.networkError(error)
        }
    }
    
    func getRecipe(with id: String) async throws -> Meal {
        Meal.preview.first!
    }
    
    private func makeListUrl() -> URL {
        var components = makeUrlComponents()
        let queryItem = URLQueryItem(name: Constants.categoryName, value: Constants.categoryFilterParamName)
        components.queryItems?.append(queryItem)
        
        guard let urlString = components.string, let result = URL(string: urlString) else {
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
    
    private func handle(data: Data, response: URLResponse) throws -> [Meal] {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RepositoryError.generalError
        }
        
        let statusCode = httpResponse.statusCode
        guard (0...200).contains(statusCode) else {
            throw RepositoryError.badResponseCode(statusCode)
        }
        
        do {
            let result = try decoder.decode([Meal].self, from: data)
            return result
        } catch {
            throw RepositoryError.generalError
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
    }
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