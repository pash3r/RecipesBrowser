//
//  RecipesBrowserApp.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

@main
struct RecipesBrowserApp: App {
    @StateObject private var recipesProvider: RecipesProvider = {
        let repository = RecipesNetworkRepository()
        return RecipesProvider(repository: repository)
    }()
    
    var body: some Scene {
        WindowGroup {
            RecipesListView(recipesProvider: recipesProvider)
        }
    }
}
