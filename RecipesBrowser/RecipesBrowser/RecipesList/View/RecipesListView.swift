//
//  RecipesListView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct RecipesListView: View {
    @ObservedObject var recipesProvider: RecipesProvider
    private let viewModel: ViewModel
    
    init(recipesProvider: RecipesProvider) {
        self.recipesProvider = recipesProvider
        self.viewModel = ViewModel(provider: recipesProvider)
    }
    
    var body: some View {
        NavigationStack {
            makeContent()
                .navigationTitle(viewModel.navigationTitle)
        }
        .task {
            await recipesProvider.loadRecipes()
        }
    }
    
    @ViewBuilder
    private func makeContent() -> some View {
        switch viewModel.state {
        case .initial:
            EmptyView()
        case .loading:
            ProgressView()
        case .loadedRecipes(let array):
            List(array, id: \.id) { item in
                NavigationLink {
                    RecipeDetailView(recipeId: item.id)
                } label: {
                    RecipeListRowView(item: item)
                }

            }
        case .error(let text):
            makeErrorView(with: text)
        }
    }
    
    private func makeErrorView(with text: String) -> some View {
        ErrorRetryView(text: text) {
            Task {
                await recipesProvider.reloadRecipes()
            }
        }
    }
}

private extension RecipesListView {
    struct ViewModel {
        let provider: RecipesProvider
        var state: State {
            var result: State
            switch provider.state {
            case .initial:
                result = .initial
            case .loading:
                result = .loading
            case .loadedRecipes(let array):
                result = .loadedRecipes(array)
            case .error: // in this case we don't care about actual error, because we always show Retry button
                let defaultText = "Something went wrong. We already know about the problem and trying to fix it."
                result = .error(defaultText)
            }
            
            return result
        }
                
        let navigationTitle: String = "Recipes"
        
        enum State {
            case initial
            case loading
            case loadedRecipes([Meal])
            case error(String)
        }
    }
}

#if DEBUG
private class RecipesRepositoryMock: RecipesRepositoryDescription {
    func getRecipes() async throws -> [Meal] {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        return Meal.preview
    }
    
    func getRecipe(with id: String) async throws -> MealDetail {
        MealDetail.preview
    }
}

#Preview {
    RecipesListView(recipesProvider: RecipesProvider(repository: RecipesRepositoryMock()))
}
#endif
