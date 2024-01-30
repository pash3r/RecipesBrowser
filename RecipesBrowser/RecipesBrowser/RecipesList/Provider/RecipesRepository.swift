//
//  RecipesRepository.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

protocol RecipesRepositoryDescription {
    func getRecipes() async throws -> [Meal]
    func getRecipe(with id: String) async throws -> Meal
}
