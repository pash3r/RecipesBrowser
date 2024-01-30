//
//  RecipeDetailView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeId: String
    @EnvironmentObject private var provider: RecipeDetailsProvider
    private let viewModel = ViewModel()
        
    var body: some View {
        VStack {
            switch viewModel.state(from: provider) {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let mealDetail):
                ScrollView {
                    VStack {
                        AsyncImage(url: mealDetail.imgUrl) { imgPhase in
                            switch imgPhase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "fork.knife.circle")
                            @unknown default:
                                Image(systemName: "fork.knife.circle")
                            }
                        }
                        
                        Text(mealDetail.name)
                        Text(mealDetail.instructions)
                    }
                }
            case .error(let text):
                ErrorRetryView(text: text) {
                    Task {
                        await provider.retry(with: recipeId)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.navbarTitle(with: provider))
        .task {
            await provider.loadRecipe(with: recipeId)
        }
    }
}

private extension RecipeDetailView {
    struct ViewModel {
        func state(from provider: RecipeDetailsProvider) -> State {
            let result: State
            switch provider.state {
            case .initial:
                result = .initial
            case .loading:
                result = .loading
            case .loaded(let recipe):
                result = .loaded(recipe)
            case .error(let text):
                result = .error(text)
            }
            
            return result
        }
        
        func navbarTitle(with provider: RecipeDetailsProvider) -> String {
            guard case let .loaded(recipe) = provider.state else {
                return ""
            }
            
            return recipe.name
        }
        
        enum State {
            case initial
            case loading
            case loaded(MealDetail)
            case error(String)
        }
    }
}

#if DEBUG
#Preview {
    RecipeDetailView(recipeId: "")
}
#endif
