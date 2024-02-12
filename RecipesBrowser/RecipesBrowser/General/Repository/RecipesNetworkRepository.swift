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
            return try await handleList(data: data, response: response)
        } catch {
            throw RepositoryError.networkError(error)
        }
    }
    
    @MainActor
    func getRecipe(with id: String) async throws -> MealDetail {
        do {
            let (data, response) = try await networkClient.load(url: makeDetailsUrl(with: id))
            return try await handleDetails(data: data, response: response)
        } catch {
            throw RepositoryError.networkError(error)
        }
    }
    
    private func makeListUrl() -> URL {
        var components = makeListUrlComponents()
        let queryItem = URLQueryItem(name: Constants.categoryQueryFilterParamName, value: Constants.categoryName)
        components.queryItems = [queryItem]
        
        guard let result = components.url else {
            fatalError("failed to create recipes URL from components: \(components)")
        }
        
        return result
    }
    
    private func makeDetailsUrl(with id: String) -> URL {
        var components = makeDetailsUrlComponents()
        components.queryItems = [URLQueryItem(name: Constants.detailsQueryParamName, value: id)]
        
        guard let result = components.url else {
            fatalError("fatal error: Failed to create URL components for recipe details with id \(id)")
        }
        
        return result
    }
    
    private func makeUrlComponents() -> URLComponents {
        guard let urlComponents = URLComponents(url: Constants.baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("fatal error: Failed to create URL components for recipes list request")
        }
        
        return urlComponents
    }
    
    private func makeListUrlComponents() -> URLComponents {
        var urlComponents = makeUrlComponents()
        urlComponents.path += Constants.categoriesPathComponent
        
        return urlComponents
    }
    
    private func makeDetailsUrlComponents() -> URLComponents {
        var components = makeUrlComponents()
        components.path += Constants.detailsPathComponent
        
        return components
    }
    
    private func handleList(data: Data, response: URLResponse) async throws -> [Meal] {
        try handle(response: response)
        
        do {
            let result = try decoder.decode(RecipesListResponse.self, from: data)
            return result.meals
        } catch {
            throw RepositoryError.decodingError(error)
        }
    }
    
    private func handleDetails(data: Data, response: URLResponse) async throws -> MealDetail {
        try handle(response: response)
        
        do {
            let parsedResponse = try decoder.decode(RecipeDetailsResponse.self, from: data)
            guard let details = parsedResponse.mealDetails else {
                throw RepositoryError.emptyResponse
            }
            
            return details
        } catch {
            throw RepositoryError.decodingError(error)
        }
    }
    
    private func handle(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RepositoryError.generalError
        }
        
        let statusCode = httpResponse.statusCode
        guard (0...200).contains(statusCode) else {
            throw RepositoryError.badResponseCode(statusCode)
        }
    }
    
    private struct Constants {
        static let baseUrl: URL = URL(string: "https://themealdb.com/api/json/v1/1/")!
        static let categoriesPathComponent: String = "filter.php"
        static let categoryQueryFilterParamName: String = "c"
        static let categoryName = "Dessert"
        static let detailsPathComponent: String = "lookup.php"
        static let detailsQueryParamName: String = "i"
    }
    
    enum RepositoryError: Error {
        case networkError(Error)
        case badResponseCode(Int)
        case generalError
        case decodingError(Error)
        case emptyResponse
    }

    struct RecipesListResponse: Decodable {
        let meals: [Meal]
    }
    
    struct RecipeDetailsResponse: Decodable {
        let meals: [[String: String?]]

        var mealDetails: MealDetail? {
            let meal = meals.first?.compactMapValues { $0 }
            return MealDetail(rawValue: meal)
        }
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
