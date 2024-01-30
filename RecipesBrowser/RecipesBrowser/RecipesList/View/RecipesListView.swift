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
            switch viewModel.state {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loadedRecipes(let array):
                List(array, id: \.id) { item in
                    NavigationLink {
                        Text("\(item.name)")
                    } label: {
                        RecipeListRowView(item: item)
                    }

                }
            case .error(let error):
                VStack {
                    Text(error.localizedDescription)
                    Button("Reload") {
                        Task {
                            await recipesProvider.loadRecipes()
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .task {
            await recipesProvider.loadRecipes()
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
            case .error(let error):
                result = .error(error)
            }
            
            return result
        }
                
        let navigationTitle: String = "Recipes"
        
        enum State {
            case initial
            case loading
            case loadedRecipes([Meal])
            case error(Error)
        }
    }
}

#if DEBUG
private class RecipesRepositoryMock: RecipesRepositoryDescription {
    func getRecipes() async throws -> [Meal] {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        return Meal.preview
    }
    
    func getRecipe(with id: String) async throws -> Meal {
        Meal.preview.first!
    }
}

#Preview {
    RecipesListView(recipesProvider: RecipesProvider(repository: RecipesRepositoryMock()))
}
#endif
