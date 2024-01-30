//
//  RecipesProvider.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

final class RecipesProvider: ObservableObject {
    @Published private(set) var state: State = .initial {
        didSet {
            debugPrint("\(type(of: self)) did change state to: \(state)")
        }
    }
    
    private let repository: RecipesRepositoryDescription
    
    init(repository: RecipesRepositoryDescription) {
        self.repository = repository
    }
    
    @MainActor
    func loadRecipes() async {
        state = .loading
        do {
            let recipes = try await repository.getRecipes()
                .sorted(by: { meal1, meal2 in
                    meal1.name < meal2.name
                })
            
            state = .loadedRecipes(recipes)
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    func reloadRecipes() async {
        await loadRecipes()
    }
    
    enum State {
        case initial
        case loading
        case loadedRecipes([Meal])
        case error(Error)
    }
}
