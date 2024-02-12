//
//  RecipesPreviewRepository.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 2/12/24.
//

import Foundation

class RecipesPreviewRepository: RecipesRepositoryDescription {
    func getRecipes() async throws -> [Meal] {
        []
    }
    
    func getRecipe(with id: String) async throws -> MealDetail {
        MealDetail.preview
    }
}
