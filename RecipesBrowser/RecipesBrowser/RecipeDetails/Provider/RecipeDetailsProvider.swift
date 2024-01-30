//
//  RecipeDetailsProvider.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

final class RecipeDetailsProvider: ObservableObject {
    @Published private(set) var state: State = .initial
    
    private let repository: RecipesRepositoryDescription
    
    init(repository: RecipesRepositoryDescription = RecipesNetworkRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func loadRecipe(with id: String) async {
        state = .loading
        
        do {
            let recipe = try await repository.getRecipe(with: id)
            state = .loaded(recipe)
        } catch {
            state = .error(error)
        }
    }
    
    func retry(with id: String) async {
        await loadRecipe(with: id)
    }
    
    enum State {
        case initial
        case loading
        case loaded(MealDetail)
        case error(Error)
    }
}
